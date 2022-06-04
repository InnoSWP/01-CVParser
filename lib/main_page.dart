import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  void _upload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );

    if (result != null) {
      final PdfDocument document = PdfDocument(
        inputBytes: result.files.single.bytes,
      );
      print(PdfTextExtractor(document).extractText());
      document.dispose();
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _upload,
        tooltip: "upload cv's",
        child: const Icon(Icons.upload_file_rounded),
      ),
    );
  }
}
