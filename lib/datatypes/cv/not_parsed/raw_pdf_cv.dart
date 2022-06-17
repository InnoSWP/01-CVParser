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
  Future<ParsedCV>? future;
  ParsedCV? cached;

  RawPdfCV({
    required filename,
    required this.readStream,
    required this.size,
  }) : super(filename);

  Future<ParsedCV> _parse({bool mock = false}) async {
    // extract text
    String text = await textExtracter.extractTextFromPdf(
      readStream, // will fail on the second call
      size,
    );

    // parse the text using iExtract API
    final res = ParsedCV(
      filename: filename,
      data: await cvParser.parseCV(text, mock: mock),
    );

    cached = res;

    return res;
  }

  @override
  bool isParseCached() {
    return future != null;
  }

  @override
  bool isParseCachedComplete() {
    return cached != null;
  }

  @override
  ParsedCV immediateParse() {
    return cached!;
  }

  @override
  Future<ParsedCV> parse({bool mock = false}) async {
    // check if it's already in process
    future ??= _parse(mock: mock);
    return await future!;
  }

  @override
  bool satisfies(RegExp query) {
    if (cached == null) {
      return true;
    }

    for (final entry in cached!.data.entries) {
      String label = entry.key;
      for (final cvmatch in entry.value) {
        String match = cvmatch.match;
        String sentence = cvmatch.sentence;

        String combine = """
          filename: $filename
          label: $label
          match: $match
          sentence: $sentence
        """;

        if (query.hasMatch(combine)) {
          return true;
        }
      }
    }
    return false;
  }
}
