import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfToText extends GetxService {
  String extractTextFromPdfBytes(List<int> bytes) {
    final PdfDocument document = PdfDocument(
      inputBytes: bytes, // TESTIT: try loading pdf with a password
    );
    // weak TODO (uploading cv): wrap this function as a future and delegate extractText
    // to the separate isolate or to the separate Worker if on web
    String text = PdfTextExtractor(document).extractText();
    document.dispose();
    return text;
  }
}
