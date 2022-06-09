import 'package:cvparser_b21_01/datatypes/all.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  /// Using lazy approach, we will initially upload cv's as [NotParsedCV],
  /// but on the first invocation it converts them to the [ParsedCV].
  final cvs = <Selectable<CVBase>>[].obs;
  final current = Rxn<ParsedCV>();

  /// Creates native dialog for user to select files
  Future<void> askUserToUploadPdfFiles() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"], // TESTIT: what if not pdf
      allowMultiple: true,
      withReadStream: true,
      withData: false,
      lockParentWindow: true,
    );

    if (picked != null) {
      for (PlatformFile file in picked.files) {
        cvs.add(
          // add an NotParsedCV
          Selectable(
            item: RawPdfCV(
              // just because it's web, we cannot store file path,
              // but we can get stream of filedata
              filename: file.name,
              readStream: file.readStream,
              size: file.size,
            ),
            isSelected: false,
          ),
        );
      }
    }
  }

  /// Provided [index] (in cvs list) of the cv that you need to display parsed,
  /// this function tryes to set the [current] getter
  /// ofcourse with the parsed cv
  ///
  /// Note that before the first call of this function
  /// the cvs[index] would return an instance of [NotParsedCV],
  /// but after the first call the same query can be upcasted to [ParsedCV]
  Future<void> setCurrent(int index) async {
    var tmp = cvs[index].item;

    // The lazy approach itself
    if (tmp is NotParsedCV) {
      cvs[index].item = CVBase(tmp.filename); // mark it as processing
      try {
        // TODO: special popup on iExtract API not working
        cvs[index].item = await tmp.parse(); // some async code
      } catch (e) {
        cvs[index].item = tmp; // so it's not processing anymore
        rethrow;
      }
    } else if (tmp is ParsedCV) {
      // it was already converted, so there is nothing to do
    } else {
      // Note that if we entered here, then the type of tmp is CVBase,
      // wich is the indicator that someone is now working on it,
      // so we can just ignore the task as it will be soon completed by
      // someone else
      return;
    }

    current.value = cvs[index].item as ParsedCV;
  }

  /// Switches select of cv
  Future<void> switchSelect(int index) async {
    cvs[index].isSelected = !cvs[index].isSelected;
    // here `Rx` knows only that we invoked getter of list,
    // but did not know what did we do with the element itself
    // so from the point of view of `Rx` it was just a lookup,
    // so to notify that it was not just a lookup, we need to set it manually
    cvs.refresh();
  }
}
