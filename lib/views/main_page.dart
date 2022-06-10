import 'dart:math';

import 'package:cvparser_b21_01/controllers/main_page.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../colors.dart';

class CardWidget extends StatefulWidget {
  // right now it only accepts title, but you can add more
  // arguments to be accepted by this widget
  const CardWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  // responsible for toggle
  bool _showData = false;
  bool aboba = true;
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          // list card containing country name
          GestureDetector(
              onTap: (){
                setState(() => _showData = !_showData);
                setState(() => aboba = !aboba);
              },
              child: Container(
                  width: 900,
                  height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 2, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.title, style: TextStyle(fontSize: 60, fontFamily: "Eczar", fontWeight: FontWeight.w400, color:  colorTextSmoothBlack)),
                            if (aboba)
                              Icon(Icons.keyboard_arrow_down_rounded, size: 55, color: colorSecondaryGreenPlant)
                            else
                              Icon(Icons.keyboard_arrow_up_rounded, size: 55, color: colorSecondaryGreenPlant)
                          ]
                      )
                  )
              )
          ),

          // this is the company card which is toggling based upon the bool
          _showData ? Container(
              padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ['Java','Python', 'C++', 'Web Development', 'AWS', 'FPGA'].map((e){
                    // make changes in the UI here for your company card
                    return Card(child:Text(e, style: TextStyle(fontSize: 20, fontFamily: 'Merriweather', color: colorTextSmoothBlack)));
                  }).toList()
              )
          ) : SizedBox() // else blank
        ]
    );
  }
}

class MainPage extends StatelessWidget {
  static const _desiredPadding = 18.0;
  MainPage({Key? key}) : super(key: key);
  final controller = Get.put(MainPageController());
  final keyLookup = Get.find<KeyListener>();

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


  Widget buildLeft(BuildContext context){
    return Container(
      child: Column(
        children: [
          Row(
              children: [logo(context), buildContact(context)]
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 50),
              child: buildParseResult(context),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: buildBottomLeft(context),
          )
        ],
      ),
    );
  }

  Widget logo(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 125, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('CVParser \niExtract', style: TextStyle(
            fontSize: 60,
            fontFamily: 'Eczar',
            fontWeight: FontWeight.w600,
            color: colorPrimaryRedCaramelDark,
            height: 0.9,
          ),
          ),
        ],
      ),
    );
  }


  Widget buildContact(BuildContext context){
    return Container(
      width: 505,
      height: 100,
      padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
          width: 400,
          height: 80,
          child: Row(
            children: [Column(
                children: const [
                  Text('Konstantin Fedorov', textAlign: TextAlign.start, style: TextStyle(height: 1.5, fontSize: 50, fontFamily: "Eczar", fontWeight: FontWeight.w400, color:  colorTextSmoothBlack)),
                  Text('k.fedorov@innopolis.university   +79221994815', textAlign: TextAlign.start, style: TextStyle(height: 0.2, fontSize: 20.2, fontFamily: "Eczar", fontWeight: FontWeight.w400, color:  colorTextSmoothBlack)),
                ]
            ), Icon(Icons.account_circle, size: 60, color: colorPrimaryRedCaramelDark)],
          )
      ),
    );
  }


  Widget buildBottomLeft(BuildContext context){
    return Container(
        width: 900,
        height: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)
        ),

        child: Padding(
            padding: EdgeInsets.fromLTRB(15, 2, 5, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Text('Pdf1', style: TextStyle(height: 1.3, fontSize: 45, fontFamily: "Eczar", fontWeight: FontWeight.w400, color: colorSurfaceSmoothGreenPlant)),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(const Size(250, 35)),
                    ),
                    onPressed: () {},
                    child: const Text("EXPORT AS JSON"),
                  ),
                ]
            )
        )
    );
  }



  Widget buildParseResult(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(50),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Column(
              children: ['Skills', 'Organization', 'Language', 'Countries', 'Publication', 'Links'].map((country){
                return CardWidget(title: country);
              }).toList()
          ),
        )
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
  Widget buildPdfIconButton(int position) {
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
      width: 520,
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
