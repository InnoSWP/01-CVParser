import 'package:flutter/material.dart';
import 'package:cvparser_b21_01/main_page.dart';

void main() {
  runApp(const CVParserApp());
}

class CVParserApp extends StatelessWidget {
  const CVParserApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Parser',
      theme: ThemeData.light(),
      home: const MainPage(),
    );
  }
}
