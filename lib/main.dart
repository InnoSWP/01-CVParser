import 'package:flutter/material.dart';
import 'package:cvparser_b21_01/main_page.dart';

void main() {
  runApp(const CVParserApp());
}

class CVParserApp extends StatelessWidget {
  const CVParserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Parser',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF864921),
          onPrimary: Color(0xFF864921),
          secondary: Color(0xFF4D6658),
          onSecondary: Color(0xFF4D6658),
          surface: Color(0xFFFBFDF7),
          onSurface: Color(0xFFF2EEE1),
          error: Color.fromARGB(255, 134, 38, 33),
          onError: Color.fromARGB(255, 134, 38, 33),
          background: Color(0xFFFBFDF7),
          onBackground: Color(0xFFFBFDF7),
        ),
      ),
      home: const MainPage(),
    );
  }
}
