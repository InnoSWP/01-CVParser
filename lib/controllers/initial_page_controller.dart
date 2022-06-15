import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/views/dialogs/fail_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

class InitialPageController extends GetxController {
  late DropzoneViewController dropzoneController;

  final isDropzoneHovered = false.obs;

  void instantiateDropzoneController(DropzoneViewController ctrl) {
    dropzoneController = ctrl;
  }

  void onDropzoneHover() {
    isDropzoneHovered.value = true;
  }

  void onDropzoneLeave() {
    isDropzoneHovered.value = false;
  }

  void uploadFilesManually() async {
    // select files blocking popup
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"], // TESTIT: what if not pdf
      allowMultiple: true,
      withReadStream: true,
      withData: false,
      lockParentWindow: true,
    );

    // get files
    if (picked != null) {
      List<RawPdfCV> cvs = [];

      for (PlatformFile file in picked.files) {
        cvs.add(
          RawPdfCV(
            filename: file.name,
            readStream: file.readStream,
          ),
        );
      }

      Get.toNamed("/main", arguments: cvs);
    }
  }

  void onDropFiles(List<dynamic>? fhs) {
    if (fhs != null) {
      List<RawPdfCV> cvs = [];
      for (final fh in fhs) {
        if (fh.name.toString().endsWith(".pdf")) {
          cvs.add(
            RawPdfCV(
              filename: fh.name,
              readStream: dropzoneController.getFileStream(fh),
            ),
          );
        }
      }

      if (cvs.isEmpty) {
        Get.dialog(
          const FailDialog(
            titleText: "File uploading failed",
            details: "please provide at least one pdf file",
          ),
        );
        return;
      }

      Get.toNamed("/main", arguments: cvs);
    }
  }
}
