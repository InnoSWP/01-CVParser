import 'package:get/get.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfToText extends GetxService {
  Future<List<int>> _drain(Stream<List<int>> readStream) async {
    final drained = <int>[];
    await for (final bucket in readStream) {
      drained.addAll(bucket);
    }
    return drained;
  }

  Future<String> extractTextFromPdf(
    Stream<List<int>> bytesStream,
    int size,
  ) async {
    final PdfDocument document = PdfDocument(
      inputBytes: await _drain(bytesStream),
    );
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }
}
