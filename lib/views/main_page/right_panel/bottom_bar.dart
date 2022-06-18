import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends GetView<MainPageController> {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: controller.exportSelected,
              child: const Text("EXPORT SELECTED AS JSON"),
            ),
            ElevatedButton(
              onPressed: controller.deleteSelected,
              child: const Text("DELETE SELECTED"),
            ),
          ],
        ),
        const SizedBox(height: 18.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: controller.selectAll,
              child: const Text("SELECT ALL"),
            ),
            ElevatedButton(
              onPressed: controller.selectParsed,
              child: const Text("SELECT PARSED"),
            ),
            ElevatedButton(
              onPressed: controller.invertSelection,
              child: const Text("INVERT SELECTION"),
            ),
          ],
        ),
      ],
    );
  }
}
