import 'dart:math';

import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PdfIconButton extends GetView<MainPageController> {
  final keyLookup = Get.find<KeyListener>();

  final int index;
  final bool isSelected;
  final String filename;

  PdfIconButton(
      {Key? key,
      required this.index,
      required this.isSelected,
      required this.filename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decor = isSelected
        ? BoxDecoration(
            color: const Color.fromARGB(10, 218, 225, 226),
            border: Border.all(
              color: const Color.fromARGB(30, 218, 225, 226),
            ),
          )
        : const BoxDecoration();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Tooltip(
        // weak TODO: make tooltip more pleasant
        // weak TODO: why selection on GestureDetector is too slow?!
        // weak TODO: beautify select UX:
        // - smooth animations of select/deselect,
        // - accent on the tile under the cursor
        // - maybe somewhere invert selection ?
        message: filename,
        child: GestureDetector(
          onTapDown: (d) {
            if (keyLookup.shift) {
              // range select
              controller.selectPoint ??= 0;
              final start = min(controller.selectPoint!, index);
              final stop = max(controller.selectPoint!, index);
              for (int i = start; i <= stop; i++) {
                controller.select(i);
              }
            } else {
              // single select
              if (!keyLookup.ctrl) {
                controller.deselectAll();
              }
              controller.switchSelect(index);
            }
            controller.selectPoint = index;
          },
          onDoubleTap: () {
            controller.setCurrent(index);
          },
          child: Container(
            decoration: decor.copyWith(
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    "icons/pdf.svg",
                    width: 43,
                    height: 52,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    filename,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
