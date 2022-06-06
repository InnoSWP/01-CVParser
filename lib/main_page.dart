import 'package:flutter/material.dart';

import 'package:cvparser_b21_01/misc.dart';

class MainPage extends StatelessWidget {
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
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Container(
            width: 400,
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: _upload,
                    child: const Text("ADD RESUMES"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
