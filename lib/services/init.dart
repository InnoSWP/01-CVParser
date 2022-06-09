import 'package:cvparser_b21_01/services/i_extract.dart';
import 'package:cvparser_b21_01/services/pdf_to_text.dart';
import 'package:get/get.dart';

// MUST be called only once in the main function before all the other stuff
void initSertvices() {
  Get.create(() => IExtract());
  Get.create(() => PdfToText());
}
