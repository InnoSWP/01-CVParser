import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/services/i_extract.dart';
import 'package:cvparser_b21_01/services/pdf_to_text.dart';
import 'package:get/get.dart';

class RawPdfCV extends NotParsedCV {
  final textExtracter = Get.find<PdfToText>();
  final cvParser = Get.find<IExtract>();
  final BytesStreamReader data;

  RawPdfCV({
    required filename,
    required readStream,
  })  : data = BytesStreamReader(
          readStream: readStream,
        ),
        super(filename);

  @override
  Future<ParsedCV> parse() async {
    // extract text
    String text = textExtracter.extractTextFromPdfBytes(
      await data.bytes,
    );

    // parse the text using iExtract API
    return ParsedCV(
      // weak TODO: rm it as it is temporary because API is not responding
      filename: filename,
      data: {
        "Skills": [
          CVMatch(match: "C++", sentence: "I love C++"),
          CVMatch(match: "Java", sentence: "I had an experience in Java"),
        ],
        "Language": [
          CVMatch(match: "Eng", sentence: "B2 english"),
        ]
      },
    );

    return ParsedCV(
      filename: filename,
      data: await cvParser.parseCV(text),
    );
  }
}
