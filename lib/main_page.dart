import 'package:flutter/material.dart';

import 'package:cvparser_b21_01/misc.dart';
import 'package:flutter_svg/svg.dart';

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
        child: ListView(
          children: [Row(
            children: [Text("label-first"),TextButton(onPressed: ()=>"aboba",child:Text("giga-button"))],
          ),Row(
            children: [Text("label-some-bullshit"),TextButton(onPressed: ()=>"aboba",child:Text("giga-button"))],
          )],
        )
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
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 400),
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
            fixedSize: MaterialStateProperty.all<Size>(const Size(200, 45)),
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
