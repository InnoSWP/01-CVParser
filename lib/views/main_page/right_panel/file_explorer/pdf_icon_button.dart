import 'dart:math';

import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PdfIconButton extends StatelessWidget {
  final controller = Get.find<MainPageController>();
  final keyLookup = Get.find<KeyListener>();

  final int position;
  final int index;
  final bool isSelected;
  final String filename;

  PdfIconButton(
      {Key? key,
      required this.position,
      required this.index,
      required this.isSelected,
      required this.filename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build $index');
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
        message: filename,
        child: GestureDetector(
          onTapDown: (d) {
            if (keyLookup.shift) {
              controller.selectPoint ??= 0;
              final start = min(controller.selectPoint!, position);
              final stop = max(controller.selectPoint!, position);
              for (int p = start; p <= stop; p++) {
                controller.select(controller.cvsS.keys.elementAt(p));
              }
            } else {
              if (!keyLookup.ctrl) {
                controller.deselectAll();
              }
              controller.switchSelect(index);
            }
            controller.selectPoint = position;
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
