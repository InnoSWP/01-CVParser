import 'package:cvparser_b21_01/controllers/initial_page_controller.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialPage extends GetView<InitialPageController> {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: Card(
            child: SizedBox(
              height: 200,
              width: 400,
              child: Container(
                color: controller.isDropzoneHovered.value
                    ? Colors.blueAccent
                    : Colors.transparent,
                child: Stack(
                  children: [
                    DropzoneView(
                      operation: DragOperation.move,
                      cursor: CursorType.grab,
                      //mime: const ["application/pdf"],
                      onCreated: controller.instantiateDropzoneController,
                      onHover: controller.onDropzoneHover,
                      onLeave: controller.onDropzoneLeave,
                      onDropMultiple: controller.onDropFiles,
                    ),
                    const Center(child: Text("drop here")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
