import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

class CVMatch {
  String match;
  String sentence;

  CVMatch({required this.match, required this.sentence});
}

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
String pdfToText(Uint8List bytes) {
  // TODO: to isolate
  final PdfDocument document = PdfDocument(
    inputBytes: bytes,
  );
  String res = PdfTextExtractor(document).extractText();
  document.dispose();
  return res;
}

/// Given [String] of text, sends it to IExtract API and returns it's result
/// in a little bit refactored format that Map represents:
/// label => [{match1, sentence1}, {match2, sentence2}, ...]
///
/// Note: web requires some walk around CORS
Future<Map<String, List<CVMatch>>> parseCv(String text) async {
  final _apiUrl =
      Uri.parse("https://aqueous-anchorage-93443.herokuapp.com/CvParser");

  final Map data = {
    "text": text,
    "keywords": "string",
    "pattern": 11,
  };

  final body = json.encode(data);
  final response = await http.post(_apiUrl,
      headers: {"Content-Type": "application/json"}, body: body);

  if (response.statusCode != 200) {
    throw response;
  }

  final parsed = jsonDecode(response.body) as List<dynamic>;

  // group entries by label

  Map<String, List<CVMatch>> res = {};

  for (dynamic elem in parsed) {
    res.putIfAbsent(elem["label"], () => []).add(
          CVMatch(
            match: elem["match"],
            sentence: elem["sentence"],
          ),
        );
  }

  return res;
}
