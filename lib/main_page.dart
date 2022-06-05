import 'package:flutter/material.dart';

import 'package:cvparser_b21_01/misc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  void _upload() async {
    List<FileData> uploaded = await askUserToUploadFiles(["pdf"]);
    for (FileData file in uploaded) {
      print(await pdfToText(file.bytes));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _upload,
        tooltip: "upload cv's",
        child: const Icon(Icons.upload_file_rounded),
      ),
    );
  }
}
