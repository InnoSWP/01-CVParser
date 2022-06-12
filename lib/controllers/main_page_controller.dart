import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/services/file_saver.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:cvparser_b21_01/views/dialogs/fail_dialog.dart';
import 'package:cvparser_b21_01/views/dialogs/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  final keyLookup = Get.find<KeyListener>();
  final fileSaver = Get.find<FileSaver>();

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
  bool _parsingCv = false; // see [_parseCV] for more details

  /// Important: before modifying this data, firstly check the [_busy] flag,
  /// also it's supposed to be any kind modified only inside this file,
  /// any outer invocation must just read data
  final cvs = <Selectable<CVBase>>[].obs;
  final _current = Rxn<ParsedCV>();

  /// used for range select
  int? selectPoint;

  /// just not to go over cvs twice in [exportSelected]
  int selected = 0;

  /// subscribe to the stream of key events
  late StreamSubscription<dynamic> _escListener;

  late StreamSubscription<dynamic> _delListener;
  ParsedCV? get current => _current.value;

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
                  readStream: file.readStream,
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
        var remaining = <Selectable<CVBase>>[];
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
        selected = 0;
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
        var done = 0;

        for (var index = 0; index != cvs.length; index++) {
          var cv = cvs[index];
          if (cv.isSelected) {
            await _parseCv(index); // make sure that all cv's are parsed
            parsedCVs.add(cv.item as ParsedCV);

            done++;
            yield ProgressDone(
              done / selected,
              "$done / $selected \n ${cv.item.filename}",
            );
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

    // ya, it's ofcource better to track the actual future instances instead of
    // just flag [_busy], and cancel them when the actual class instance becomes
    // destroyed, but it's muuuch complex, moreover the class instance is
    // supposed to be destroyed on the application exit, so all of them would be
    // forced to end up with him

    super.onClose();
  }

  @override
  void onInit() {
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
    super.onInit();
  }

  /// Switches select of cv
  void select(int index) {
    _syncSafe(
      () {
        cvs[index].isSelected = true;
        selected++;
        cvs.refresh();
      },
    );
  }

  /// Tries to select all
  void selectAll() {
    _syncSafe(
      () {
        for (var cv in cvs) {
          cv.isSelected = true;
        }
        selected = cvs.length;
        cvs.refresh();
      },
    );
  }

  /// Tries to parse this CV and then set the [current]
  void setCurrent(int index) {
    _asyncSafe(
      "Parsing results",
      () async* {
        await _parseCv(index);
        _current.value = (cvs[index].item as ParsedCV);
      },
    );
  }

  /// Switches select of cv
  void switchSelect(int index) {
    _syncSafe(
      () {
        cvs[index].isSelected = !cvs[index].isSelected;
        selected += cvs[index].isSelected ? 1 : -1;
        cvs.refresh();
      },
    );
  }

  /// Wrapper method to make it safe, see [_busy]
  /// it also handles crushes of coroutines
  /// and is responsible for blocking dialog popup
  void _asyncSafe(
    String dialogTitle,
    Stream<ProgressDone> Function() coroutine,
  ) {
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
  ///
  /// Note: this function is always invoked with [_busy] flag equals to true,
  /// as it is just a subroutine function for [exportSelected] and [setCurrent]
  /// so this is the reason why we don't block it with [_busy] flag,
  /// but it uses it's own [_parsingCv]
  Future<void> _parseCv(int index) async {
    assert(!_parsingCv);
    assert(_busy);

    _parsingCv = true;
    try {
      var tmp = cvs[index].item;

      // The lazy approach itself
      if (tmp is NotParsedCV) {
        cvs[index].item = CVBase(tmp.filename); // mark it as processing
        try {
          cvs[index].item = await tmp.parse(); // some async code
        } catch (e) {
          cvs[index].item = tmp; // so it's not processing anymore
          rethrow;
        }
      } else if (tmp is ParsedCV) {
        // it was already converted, so there is nothing to do
      } else {
        // if we entered here, then the type of tmp is CVBase,
        // which is the indicator that someone is now working on it.
        throw TypeError();

        // Fatal: if you ever see this exception, means that the overall
        // data protection logic (see flag [_busy]) does not work
        // as only [_parseCV] ignores [_busy] flag and only it can be run
        // concurrently on cvs
        // but newertheless we expect only one instance of such futre to work
        // on the [cvs] at the same time

        // note that this thing actually would not be ever fired
        // because now it is totally covered by [_parsingCv] flag
      }
    } catch (e) {
      _parsingCv = false;
      rethrow;
    } finally {
      _parsingCv = false;
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
