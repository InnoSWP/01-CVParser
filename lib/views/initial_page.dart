import 'package:cvparser_b21_01/controllers/initial_page_controller.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:cvparser_b21_01/colors.dart';

class InitialPage extends GetView<InitialPageController> {
  const InitialPage({Key? key}) : super(key: key);

  Widget contentLogo(BuildContext context) {
    return Column(children: [
      Container(
        width: 200,
        height: MediaQuery.of(context).size.height / 2.2,
      ),
      Container(
          child: Text(
        'CVParser',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 10,
          fontFamily: 'Eczar',
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onPrimary,
          height: 0.5,
        ),
      )),
      Expanded(
          child: Container(
              child: Text(
        '“we help you search in your CVs faster”',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 42,
          fontFamily: 'Eczar',
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.secondary,
          height: 0.5,
        ),
      ))),
      Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'powered by iExtract',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 50,
                fontFamily: 'Eczar',
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
                height: 1,
              ),
            )),
      ),
    ]);
  }

  Widget uploaderRight(BuildContext context) {
    return Obx(
      () => Center(
        child: Card(
          color: Theme.of(context).colorScheme.secondary,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 180,
            width: (MediaQuery.of(context).size.width / 2) - 180,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: controller.isDropzoneHovered.value
                    ? Theme.of(context).colorScheme.onSecondary
                    : Theme.of(context).colorScheme.onSecondary, // TODO: todo
              ),
              child: Stack(
                children: [
                  DropzoneView(
                    operation: DragOperation.move,
                    cursor: CursorType.grab,
                    onCreated: controller.instantiateDropzoneController,
                    onHover: controller.onDropzoneHover,
                    onLeave: controller.onDropzoneLeave,
                    onDropMultiple: controller.onDropFiles,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: SvgPicture.asset(
                          "icons/icon.svg",
                          width: 300,
                          height: 300,
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: Column(children: [
                            ElevatedButton(
                              onPressed: controller.uploadFilesManually,
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context)
                                    .colorScheme
                                    .secondary, // Background color
                                fixedSize: const Size(300, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("ADD CVs",
                                  style: TextStyle(
                                    fontFamily: "Merriweather",
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: 20,
                                  )),
                            ),
                            const Center(
                              child: Text(
                                "or drop CVs here",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Merriweather",
                                  fontWeight: FontWeight.w400,
                                  height: 1.8,
                                  color: colorSecondaryGreenPlant,
                                ),
                              ),
                            ),
                          ])),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                child: contentLogo(context)),
            Container(
                color: Theme.of(context).colorScheme.secondary,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                child: uploaderRight(context)),
          ],
        ));
  }
}