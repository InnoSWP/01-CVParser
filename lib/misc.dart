import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileData {
  final String name;
  final Uint8List bytes;

  FileData({required this.name, required this.bytes});
}

/// Creates native dialog for user to select files, then fetches files by itself
/// and returns it's content in a stream of [FileData]
///
/// In case user cancelled this action, it will return empty stream
///
/// Note: tested only on web
Future<List<FileData>> askUserToUploadFiles([
  List<String>? allowedExtensions,
]) async {
  FilePickerResult? picked = await FilePicker.platform.pickFiles(
    type: allowedExtensions == null ? FileType.any : FileType.custom,
    allowedExtensions: allowedExtensions,
    allowMultiple: true,
  );

  List<FileData> res = [];

  if (picked != null) {
    for (PlatformFile file in picked.files) {
      res.add(
        FileData(
          name: file.name,
          bytes: file.bytes!,
        ),
      );
    }
  } else {
    // User canceled the picker, so the stream would be empty
  }

  return res;
}

/// Given [Uint8List] of a pdf document bytes, extracts text from it
Future<String> pdfToText(Uint8List bytes) async {
  // TODO: to isolate
  final PdfDocument document = PdfDocument(
    inputBytes: bytes,
  );
  String res = PdfTextExtractor(document).extractText();
  document.dispose();
  return res;
}
