import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Contact extends GetView<MainPageController> {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Flexible(
          child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 100,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Text(
                    controller.current?.data['PERSON']?[0].match ?? 'no name',
                    style: TextStyle(
                      height: 1.5,
                      fontSize: MediaQuery.of(context).size.width / 30,
                      fontFamily: "Eczar",
                      fontWeight: FontWeight.w400,
                      color: colorTextSmoothBlack,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    controller.current?.data['emails']?[0].match ?? 'no email',
                    style: TextStyle(
                      height: 1,
                      fontSize: MediaQuery.of(context).size.width / 73,
                      fontFamily: "Eczar",
                      fontWeight: FontWeight.w400,
                      color: colorTextSmoothBlack,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ])),
            if (MediaQuery.of(context).size.width > 1340)
              const Icon(Icons.account_circle,
                  size: 60, color: colorPrimaryRedCaramelDark)
          ],
        ),
      ));
    });
  }
}
