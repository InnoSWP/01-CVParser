import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/services/i_extract.dart';
import 'package:cvparser_b21_01/services/pdf_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class RawPdfCV extends NotParsedCV {
  final textExtracter = Get.find<PdfToText>();
  final cvParser = Get.find<IExtract>();
  final Stream<List<int>> readStream;
  final int size;

  RawPdfCV({
    required filename,
    required this.readStream,
    required this.size,
  }) : super(filename);

  /// Note: don't call it twice
  @override
  Future<ParsedCV> parse({bool mock = false}) async {
    // extract text
    String text = await textExtracter.extractTextFromPdf(
      readStream, // will fail on the second call
      size,
    );

    // parse the text using iExtract API
    return ParsedCV(
      filename: filename,
      data: await cvParser.parseCV(text, mock: mock),
    );
  }
}
