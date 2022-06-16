import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:should_rebuild/should_rebuild.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'file_explorer/pdf_icon_button.dart';

class FileExplorer extends GetView<MainPageController> {
  final keyLookup = Get.find<KeyListener>();

  FileExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // weak TODO: this big plus icon on no cvs
    return Obx(
      () => GridView.builder(
        itemCount: controller.cvs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final tile = controller.cvs[index];
          return ShouldRebuild<PdfIconButton>(
            shouldRebuild: (oldWidget, newWidget) =>
                oldWidget.filename != newWidget.filename ||
                oldWidget.isSelected != newWidget.isSelected,
            child: PdfIconButton(
              index: index,
              isSelected: tile.isSelected,
              filename: tile.item.filename,
              isParsed: tile.item is ParsedCV,
            ),
          );
        },
      ),
    );
  }
}
