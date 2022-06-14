import 'dart:math';

import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cvparser_b21_01/views/tooltip.dart' as my_tooltip;

class PdfIconButton extends StatefulWidget {
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
  State<PdfIconButton> createState() => _PdfIconButtonState();
}

class _PdfIconButtonState extends State<PdfIconButton> {
  final controller = Get.find<MainPageController>();
  final keyLookup = Get.find<KeyListener>();

  var hovered = false;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decor = widget.isSelected
        ? BoxDecoration(
            color: const Color.fromARGB(10, 218, 225, 226),
            border: Border.all(
              color: const Color.fromARGB(30, 218, 225, 226),
            ),
          )
        : const BoxDecoration();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            hovered = false;
          });
        },
        child: GestureDetector(
          onPanDown: (d) {
            if (keyLookup.shift) {
              // range select
              controller.selectPoint ??= 0;
              final start = min(controller.selectPoint!, widget.index);
              final stop = max(controller.selectPoint!, widget.index);
              for (int i = start; i <= stop; i++) {
                controller.select(i);
              }
            } else {
              // single select
              if (!keyLookup.ctrl) {
                controller.deselectAll();
              }
              controller.switchSelect(widget.index);
            }
            controller.selectPoint = widget.index;
          },
          onDoubleTap: () {
            controller.setCurrent(widget.index);
          },
          child: my_tooltip.Tooltip(
            message: widget.filename,
            child: Container(
              decoration: decor.copyWith(
                color: hovered ? const Color.fromARGB(10, 218, 225, 226) : null,
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
                      widget.filename,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
