import 'package:flutter/material.dart';
import 'package:cvparser_b21_01/main_page.dart';
import 'colors.dart' as my_colors;

void main() {
  runApp(const CVParserApp());
}

class CVParserApp extends StatelessWidget {
  const CVParserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainButtonTheme = ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          my_colors.colorSecondaryLightGreenPlant,
        ),
      ),
    );

    final mainTheme = ThemeData(
      colorScheme: my_colors.colorScheme,
      elevatedButtonTheme: mainButtonTheme,
      fontFamily: "Merriweather",
    );

    return MaterialApp(
      title: 'CV Parser',
      theme: mainTheme,
      home: const MainPage(),
    );
  }
}
