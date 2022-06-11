import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends StatelessWidget {
  final controller = Get.find<MainPageController>();

  TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Theme(
          data: Theme.of(context)
              .copyWith(primaryColor: colorSecondaryLightGreenPlant),
          child: TextField(
            cursorColor: colorSecondaryLightGreenPlant,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    const BorderSide(color: colorSecondaryLightGreenPlant),
              ),
              hintText: "Search",
              prefixIcon: const Icon(Icons.search,
                  color: colorSecondaryLightGreenPlant),
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 450),
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        ElevatedButton(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 20,
                fontFamily: "Merriweather",
                fontWeight: FontWeight.w600,
              ),
            ),
            fixedSize: MaterialStateProperty.all<Size>(const Size(250, 55)),
          ),
          onPressed: controller.askUserToUploadPdfFiles,
          child: const Text("ADD RESUMES"),
        ),
      ],
    );
  }
}
