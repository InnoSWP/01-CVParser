import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends GetView<MainPageController> {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 5.0),
        TextField(
          onSubmitted: controller.updateFileExplorerQuery,
          style: const TextStyle(color: colorTextSmoothBlack),
          cursorColor: colorTextSmoothBlack,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: colorTextSmoothBlack, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: colorTextSmoothBlack, width: 2),
            ),
            hintText: "Search",
            hintStyle: const TextStyle(color: colorTextSmoothBlack),
            prefixIcon: const Icon(Icons.search, color: colorTextSmoothBlack),
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 450),
            contentPadding: const EdgeInsets.all(0),
          ),
        ),
        const SizedBox(height: 18.0),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onSurface),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 30,
                fontFamily: "Merriweather",
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 3),
              borderRadius: BorderRadius.circular(10),
            )),
            fixedSize: MaterialStateProperty.all<Size>(const Size(340, 80)),
          ),
          onPressed: controller.askUserToUploadPdfFiles,
          child: const Text("ADD CVs"),
        ),
      ],
    );
  }
}
