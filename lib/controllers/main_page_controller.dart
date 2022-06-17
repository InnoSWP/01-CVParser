import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/services/file_saver.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:cvparser_b21_01/views/dialogs/fail_dialog.dart';
import 'package:cvparser_b21_01/views/dialogs/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

// TODO: refactor (separate services, rearrange datatypes (especially cv's))

class MainPageController extends GetxController {
  final keyLookup = Get.find<KeyListener>();
  final fileSaver = Get.find<FileSaver>();

  late final CancelableOperation dummyWorker;

  RegExp fileExplorerQuery = RegExp("");
  RegExp contentAreaQuery = RegExp("");

  /// Using lazy approach, we will initially upload cv's as [NotParsedCV],
  /// but on the first invocation it converts them to the [ParsedCV].

  /// As we have async methods, we need to prevent undefined behaviour
  /// when two coroutines modify the same data.
  /// For this, we will block methods invocation with [_busy] flag
  /// untill the occupator future is done.
  ///
  /// Note: there can be only one sync/async worker that
  /// is working with the data inside this class
  bool _busy = false;

  /// Important: before modifying this data, firstly check the [_busy] flag,
  /// also it's supposed to be any kind modified only inside this file,
  /// any outer invocation must just read data
  final cvs = <Selectable<NotParsedCV>>[].obs;
  final _current = Rxn<ParsedCV>();

  /// used for range select
  int? selectPoint;

  /// subscribe to the stream of key events
  late StreamSubscription<dynamic> _escListener;
  late StreamSubscription<dynamic> _delListener;

  /// get current applying search filter to it
  ParsedCV? get current {
    ParsedCV? res = _current.value;

    // pass unfiltered
    if (res == null) {
      return res;
    }

    // filter
    CVEntries filteredEntries = {};

    for (final entry in res.data.entries) {
      String label = entry.key;
      final filteredMatches = <CVMatch>[];
      for (final cvmatch in entry.value) {
        String match = cvmatch.match;
        String sentence = cvmatch.sentence;

        String combine = """
          label: $label
          match: $match
          sentence: $sentence
        """;

        if (contentAreaQuery.hasMatch(combine)) {
          filteredMatches.add(cvmatch);
        }
      }

      if (filteredMatches.isNotEmpty) {
        filteredEntries[label] = filteredMatches;
      }
    }

    return ParsedCV(
      filename: res.filename,
      data: filteredEntries,
    );
  }

  /// may be used by view to filter what it need to display
  List<Selectable<NotParsedCV>> get filteredCvs {
    final res = <Selectable<NotParsedCV>>[];
    for (final packet in cvs) {
      final cv = packet.item;
      if (cv.satisfies(fileExplorerQuery)) {
        res.add(packet);
      } else {
        // whenever files become displayed, it deselects undisplayed ones
        packet.isSelected = false;
      }
    }
    return res;
  }

  /// Creates native dialog for user to select files
  void askUserToUploadPdfFiles() {
    _asyncSafe(
      "File uploader",
      () async* {
        yield ProgressDone(null, "waiting for user");

        FilePickerResult? picked = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["pdf"], // TESTIT: what if not pdf
          allowMultiple: true,
          withReadStream: true,
          withData: false,
          lockParentWindow: true,
        );

        // if cvs is not blocked and there is some input
        if (picked != null) {
          final len = picked.files.length;
          var done = 0;

          for (PlatformFile file in picked.files) {
            // add an NotParsedCV
            cvs.add(
              Selectable(
                item: RawPdfCV(
                  // just because it's web, we cannot store file path,
                  // but we can get stream of filedata
                  filename: file.name,
                  readStream: file.readStream!,
                  size: file.size,
                ),
                isSelected: false,
              ),
            );

            done++;
            yield ProgressDone(
              done / len,
              "$done / $len",
            );
          }
        }
      },
    );
  }

  /// Tries to delete selected
  void deleteSelected() {
    _syncSafe(
      () {
        var remaining = <Selectable<NotParsedCV>>[];
        for (var cv in cvs) {
          if (!cv.isSelected) {
            remaining.add(cv);
          }
        }
        cvs.value = remaining;
        selectPoint = null;
      },
    );
  }

  /// Tries to deselect all
  void deselectAll() {
    _syncSafe(
      () {
        for (var cv in cvs) {
          cv.isSelected = false;
        }
        cvs.refresh();
      },
    );
  }

  void exportCurrent() {
    _asyncSafe(
      "Exporting",
      () async* {
        // export to json string
        const encoder = JsonEncoder.withIndent("  ");
        String encoded = encoder.convert(current);

        // save to file
        await fileSaver.saveJsonFile(
          name: "single.json",
          bytes: Uint8List.fromList(encoded.codeUnits),
        );
      },
    );
  }

  /// Try to export selected
  void exportSelected() {
    _asyncSafe(
      "Exporting",
      () async* {
        List<ParsedCV> parsedCVs = [];
        var current = 0;
        var selected = 0;

        for (final cv in cvs) {
          if (cv.isSelected) {
            selected++;
          }
        }

        for (var index = 0; index != cvs.length; index++) {
          var cv = cvs[index];
          if (cv.isSelected) {
            // notify that we are parsing something
            current++;
            yield ProgressDone(
              current / selected,
              "$current / $selected \n ${cv.item.filename}",
            );

            // make sure that all cv's are parsed
            try {
              parsedCVs.add(await _parsedCv(index, mock: true));
            } catch (e) {
              index--;
              yield ProgressDone(
                current / selected,
                "$current / $selected \n ${cv.item.filename} failed to parse",
              );
              await Future.delayed(const Duration(milliseconds: 500));
            }
          }
        }

        // export to json file and save it
        {
          // export to json string
          const encoder = JsonEncoder.withIndent("  ");
          String encoded = encoder.convert(parsedCVs);

          // save to file
          await fileSaver.saveJsonFile(
            name: "bunch.json",
            bytes: Uint8List.fromList(encoded.codeUnits),
          );
        }
      },
    );
  }

  @override
  void onClose() async {
    await _escListener.cancel();
    await _delListener.cancel();

    dummyWorker.cancel();

    // ya, it's ofcource better to track the actual future instances instead of
    // just flag [_busy], and cancel them when the actual class instance becomes
    // destroyed, but it's muuuch complex, moreover the class instance is
    // supposed to be destroyed on the application exit, so all of them would be
    // forced to end up with him

    super.onClose();
  }

  @override
  void onInit() {
    // setup keyboard listeners
    _escListener = keyLookup.escEventStream.listen((event) {
      if (event == KeyEventType.down) {
        deselectAll();
      }
    });
    _delListener = keyLookup.delEventStream.listen((event) {
      if (event == KeyEventType.down) {
        deleteSelected();
      }
    });

    // setup a dummy worker
    dummyWorker = CancelableOperation.fromFuture(
      Future(() async {
        int index = 0;
        while (true) {
          // iterate and parse CV's
          if (cvs.isNotEmpty) {
            index %= cvs.length;
            if (!cvs[index].item.isParseCached()) {
              try {
                await _parsedCv(index, mock: true);
              } catch (e) {}
              index = 0;
            } else {
              index++;
            }
          }

          // delay not to overload system
          await Future.delayed(const Duration(milliseconds: 16));
        }
      }),
    );

    // retrive data from route
    if (Get.arguments != null) {
      for (RawPdfCV cv in Get.arguments) {
        cvs.add(
          Selectable(
            item: cv,
            isSelected: false,
          ),
        );
      }
    }

    super.onInit();
  }

  /// Switches select of cv
  void select(int index) {
    _syncSafe(
      () {
        cvs[index].isSelected = true;
        cvs.refresh();
      },
    );
  }

  /// Select all that matches query
  void selectAll() {
    _syncSafe(
      () {
        for (final cv in cvs) {
          cv.isSelected = cv.item.satisfies(fileExplorerQuery);
        }
        cvs.refresh();
        // then filteredCvs will deselect undisplayed ones
      },
    );
  }

  /// Select parsed that matches query
  void selectParsed() {
    _syncSafe(
      () {
        for (final cv in cvs) {
          cv.isSelected = cv.item.isParseCachedComplete() &&
              cv.item.satisfies(fileExplorerQuery);
        }
        cvs.refresh();
        // then filteredCvs will deselect undisplayed ones
      },
    );
  }

  /// Invertes selection
  void invertSelection() {
    _syncSafe(
      () {
        for (final cv in cvs) {
          cv.isSelected = !cv.isSelected;
        }
        cvs.refresh();
        // then filteredCvs will deselect undisplayed ones
      },
    );
  }

  /// Tries to parse this CV and then set the [current]
  void setCurrent(int index) {
    _asyncSafe(
      "Parsing results",
      () async* {
        _current.value = await _parsedCv(index, mock: true);
      },
    );
  }

  /// Switches select of cv
  void switchSelect(int index) {
    _syncSafe(
      () {
        cvs[index].isSelected = !cvs[index].isSelected;
        cvs.refresh();
      },
    );
  }

  /// apply new search filter
  void updateFileExplorerQuery(String text) {
    try {
      fileExplorerQuery = RegExp(text);
    } catch (e) {
      fileExplorerQuery = RegExp("");
    }
    cvs.refresh();
  }

  /// Wrapper method to make it safe, see [_busy]
  /// it also handles crushes of coroutines
  /// and is responsible for blocking dialog popup
  void _asyncSafe(
    String dialogTitle,
    Stream<ProgressDone> Function() coroutine,
  ) {
    // TODO: cancellable
    if (_busy) {
      return;
    }
    _busy = true;
    final safeProgressStream = StreamController<ProgressDone>();

    Get.dialog(
      ProgressDialog(
        titleText: dialogTitle,
        progressStream: safeProgressStream.stream,
      ),
      barrierDismissible: false, // make it blocking
    );

    finalize() {
      _busy = false;
      Get.back();
      safeProgressStream.close();
    }

    safeProgressStream.add(ProgressDone(0, "please wait..."));
    coroutine().listen(
      safeProgressStream.add,
      onDone: () {
        safeProgressStream.add(ProgressDone(1, "done!"));
        finalize();
      },
      onError: (e) {
        finalize();
        Get.dialog(
          FailDialog(
            titleText: "Action failed",
            details: e.toString(),
          ),
        );
      },
      cancelOnError: true,
    );
  }

  /// This function will create a future that will:
  /// 1. take the element at index
  /// 2. try to parse it
  /// 3. try to store the procession result into the same index
  ///
  /// Note: will fo nothing if the item was already parsed
  /// Note2: will sync with the first invocation of itself
  Future<ParsedCV> _parsedCv(int index, {bool mock = false}) async {
    try {
      bool wasCached = !cvs[index].item.isParseCached();
      final res = await cvs[index].item.parse(mock: mock);
      // here cvs[index].item will be in state cache completed
      if (wasCached) {
        cvs.refresh();
      }
      return res;
    } catch (e) {
      cvs.removeAt(index); // as now readStream is invalid
      // TODO: show popup
      rethrow;
    }
  }

  void _syncSafe(
    void Function() func,
  ) {
    if (_busy) {
      return;
    } // no need to mark _busy because this is a synchronus function

    try {
      func();
    } catch (e) {
      Get.dialog(
        FailDialog(
          titleText: "Action failed",
          details: e.toString(),
        ),
      );
    }
  }
}
