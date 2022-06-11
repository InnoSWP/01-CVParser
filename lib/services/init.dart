import 'i_extract.dart';
import 'key_listener.dart';
import 'pdf_to_text.dart';
import 'package:get/get.dart';

// MUST be called only once in the main function before all the other stuff
void initServices() {
  Get.put(IExtract());
  Get.put(PdfToText());
  Get.put(KeyListener());
}
