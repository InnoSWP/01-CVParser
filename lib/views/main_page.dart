import 'dart:math';

import 'package:cvparser_b21_01/controllers/main_page.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  static const _desiredPadding = 18.0;
  const MainPage({Key? key}) : super(key: key);
  final controller = Get.put(MainPageController());
  final keyLookup = Get.find<KeyListener>();

  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildLeft(context),
          buildRightTab(context),
        ],
      ),
    );
  }

  Widget buildParseResult(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildRightTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_desiredPadding),
      width: 400,
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTopBar(context),
          const SizedBox(height: _desiredPadding),
          Expanded(
            child: buildFileExplorer(context),
          ),
          const SizedBox(height: _desiredPadding),
          buildBottomBar(context),
        ],
      ),
    );
  }

  Widget buildFileExplorer(BuildContext context) {
    // weak TODO: beautify select UX:
    // - smooth animations of select/deselect,
    // - accent on the tile under the cursor
    // - select all becomes deselect all if all is selected
    // - maybe somewhere insert selection ?
    // weak TODO: this big plus icon on no cvs
    return Obx(() {
      return GridView.builder(
        itemCount: controller.cvsS.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, position) {
          return buildPdfIconButton(position);
        },
      );
    });
  }

  // 3 TODO (uploading cv): merge ui
  // 4 TODO (uploading cv): bind merged ui with controller
  Widget buildPdfIconButton(String name, bool isSelected) {
    // weak TODO: separate class and optimize rebuilds with no changes
    final index = controller.cvsS.keys.elementAt(position);
    final tile = controller.cvsS[index]!;
    final BoxDecoration decor = tile.isSelected
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
        message: tile.item.filename,
        child: GestureDetector(
          onTap: () {
            if (keyLookup.shift) {
              controller.selectPoint ??= 0;
              final start = min(controller.selectPoint!, position);
              final stop = max(controller.selectPoint!, position);
              for (int i = start; i <= stop; i++) {
                controller.select(i);
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
                    tile.item.filename,
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

  Widget buildRightTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_desiredPadding),
      width: 400,
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTopBar(context),
          const SizedBox(height: _desiredPadding),
          Expanded(
            child: buildFileExplorer(context),
          ),
          const SizedBox(height: _desiredPadding),
          buildBottomBar(context),
        ],
      ),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Theme(
          data: Theme.of(context).copyWith(primaryColor: colorSecondaryLightGreenPlant),
          child:TextField(
            cursorColor: colorSecondaryLightGreenPlant,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: colorSecondaryLightGreenPlant),
              ),
              hintText: "Search",
              prefixIcon: const Icon(Icons.search, color: colorSecondaryLightGreenPlant),
              constraints: const BoxConstraints(maxHeight: 40, maxWidth: 450),
              contentPadding: const EdgeInsets.all(0),
            ),
          ),
        ),
        const SizedBox(height: _desiredPadding),
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

  Widget buildBottomBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text("EXPORT SELECTED AS JSON"),
        ),
        const SizedBox(height: _desiredPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text("SELECT ALL"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("DELETE SELECTED"),
            ),
          ],
        ),
      ],
    );
  }
}
