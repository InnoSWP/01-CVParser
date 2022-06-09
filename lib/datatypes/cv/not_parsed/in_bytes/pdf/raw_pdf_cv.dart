import 'dart:convert';

import 'package:cvparser_b21_01/datatypes/all.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

import '../raw_bytes_cv.dart';

class RawPdfCV extends RawBytesCV {
  RawPdfCV({
    required filename,
    required readStream,
    required size,
  }) : super(
          filename: filename,
          readStream: readStream,
          size: size,
        );

  @override
  Future<ParsedCV> parse() async {
    Map<String, List<CVMatch>> parsedData = {};

    // extract text
    String text;
    {
      final PdfDocument document = PdfDocument(
        inputBytes:
            await super.bytes, // TESTIT: try loading pdf with a password
      );
      text = PdfTextExtractor(document).extractText();
      document.dispose();
    }

    // parse text using iExtract API // TODO: special popup on API not working
    return ParsedCV(
      // TODO: rm it as it is temporary because API is not responding
      filename: filename,
      data: parsedData,
    );

    {
      final apiUrl =
          Uri.parse("https://aqueous-anchorage-93443.herokuapp.com/CvParser");

      final Map data = {
        "text": text,
        "keywords": "string",
        "pattern": 11,
      };
      final body = json.encode(data);

      final response = await http.post(apiUrl,
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode != 200) {
        throw response;
      }

      final parsed = jsonDecode(response.body) as List<dynamic>;

      // group entries by label

      for (dynamic elem in parsed) {
        parsedData.putIfAbsent(elem["label"], () => []).add(
              CVMatch(
                match: elem["match"],
                sentence: elem["sentence"],
              ),
            );
      }
    }

    return ParsedCV(
      filename: filename,
      data: parsedData,
    );
  }
}
