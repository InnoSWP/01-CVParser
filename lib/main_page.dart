import 'dart:html';

import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cvparser_b21_01/misc.dart';
import 'package:flutter_svg/svg.dart';

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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // add your other icon here
                            Text(widget.title, style: TextStyle(fontSize: 60, fontFamily: "Eczar", fontWeight: FontWeight.w400, color:  colorTextSmoothBlack)),
                          ]
                      )
                  )
              )
          ),

          // this is the company card which is toggling based upon the bool
          _showData ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ['SomeInfo','AnotherInfo'].map((e){
                // make changes in the UI here for your company card
                return Card(child: Text(e));
              }).toList()
          ) : SizedBox() // else blank
        ]
    );
  }
}

class MainPage extends StatelessWidget {
  static const _desiredPadding = 18.0;
  const MainPage({Key? key}) : super(key: key);

  void _upload() async {
    List<FileData> uploaded = await askUserToUploadFiles(["pdf"]);
    for (FileData file in uploaded) {
      String text = pdfToText(file.bytes);
      print(await parseCv(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildParseResult(context),
          buildRightTab(context),
        ],
      ),
    );
  }

  Widget buildParseResult(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          child:Column(
              children: ['Skills', 'Organization', 'Language', 'Countries', 'Publication', 'Links'].map((country){
                return CardWidget(title: country);
              }).toList()
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

  Widget buildFileExplorer(BuildContext context) {
    return GridView.builder(
      itemCount: 20,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return buildPdfIconButton(
            "kekuskurum_bus_kus_kus_${index + 1}.pdf", index < 5);
      },
    );
  }

  Widget buildPdfIconButton(String name, bool isSelected) {
    final BoxDecoration decor = isSelected
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
        // TODO: make tooltip more pleasant
        message: name,
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
                  name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextField(
          // TODO: beutify it
          cursorColor: colorSecondaryLightGreenPlant,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 450),
            contentPadding: const EdgeInsets.all(0),
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
          onPressed: _upload,
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
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(const Size(250, 35)),
          ),
          onPressed: () {},
          child: const Text("EXPORT SELECTED AS JSON"),
        ),
        const SizedBox(height: _desiredPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(const Size(200, 35)),
              ),
              onPressed: () {},
              child: const Text("SELECT ALL"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(const Size(200, 35)),
              ),
              onPressed: () {},
              child: const Text("DELETE SELECTED"),
            ),
          ],
        ),
      ],
    );
  }
}
