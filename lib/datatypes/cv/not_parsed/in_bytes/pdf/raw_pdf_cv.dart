import 'package:cvparser_b21_01/datatypes/all.dart';
import 'package:cvparser_b21_01/services/i_extract.dart';
import 'package:cvparser_b21_01/services/pdf_to_text.dart';
import 'package:get/get.dart';

import '../../../parsed/parsed_cv.dart';
import '../raw_bytes_cv.dart';

class RawPdfCV extends RawBytesCV {
  final textExtracter = Get.find<PdfToText>();
  final cvParser = Get.find<IExtract>();

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
    // extract text
    String text = textExtracter.extractTextFromPdfBytes(
      await bytes, // NOTE: may be infinite if size was provided incorrect
    );

    // parse the text using iExtract API
    return ParsedCV(
      // TODO: rm it as it is temporary because API is not responding
      filename: filename,
      data: {},
    );

    return ParsedCV(
      filename: filename,
      data: await cvParser.parseCV(text),
    );
  }
}
