import 'package:cvparser_b21_01/controllers/initial_page_controller.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cvparser_b21_01/colors.dart';

class InitialPage extends GetView<InitialPageController>{
  const InitialPage({Key? key}) : super(key: key);

  Widget contentLogo(BuildContext context) {
    return Column(
        children: [
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
            )
          ),
          Expanded(child: Container(
              child: Text(
                '“we help you search in your CVs faster”',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 42,
                  fontFamily: 'Eczar',
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                  height: 0.5,
                ),
              )
          )),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
              child: Align(alignment: Alignment.bottomRight, child: Text(
                'powered by iExtract',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 50,
                  fontFamily: 'Eczar',
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                  height: 1,
                ),
              )
          ),
          ),
        ]
    );
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
                      : Theme.of(context).colorScheme.onSecondary,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(child: Icon(size: MediaQuery.of(context).size.height / 3.2, color: Theme.of(context).colorScheme.primary, Icons.file_open_rounded)),
                          //TODO add a button for adding CVs
                          const Center(child: Text("or drop CVs here", style: TextStyle(fontSize: 20,
                            fontFamily: "Merriweather",
                            fontWeight: FontWeight.w400,
                            color: colorSecondaryGreenPlant,))),
                        ],
                      )
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
      body:Row(
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
      )
    );
  }
}
