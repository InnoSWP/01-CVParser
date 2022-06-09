import 'package:cvparser_b21_01/datatypes/all.dart';
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
    required size,
  })  : data = BytesStreamReader(
          readStream: readStream,
          size: size,
        ),
        super(filename);

  @override
  Future<ParsedCV> parse() async {
    // extract text
    String text = textExtracter.extractTextFromPdfBytes(
      await data.bytes, // NOTE: may be infinite if size was provided incorrect
    );

    // parse the text using iExtract API
    // return ParsedCV(
    //   // TODO: rm it as it is temporary because API is not responding
    //   filename: filename,
    //   data: {},
    // );

    return ParsedCV(
      filename: filename,
      data: await cvParser.parseCV(text),
    );
  }
}
