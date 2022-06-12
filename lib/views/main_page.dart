import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/views/main_page/content_area.dart';
import 'package:cvparser_b21_01/views/main_page/right_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final controller = Get.put(MainPageController());

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(scrollDirection: Axis.vertical, child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: MediaQuery.of(context).size.width - 500, height: MediaQuery.of(context).size.height, child: ContentArea()),
            SizedBox(width: 500, height: MediaQuery.of(context).size.height, child: RightPanel()),
          ],
        ),
    ),
    );
  }
}
