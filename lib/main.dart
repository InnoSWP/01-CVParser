import 'package:flutter/material.dart';
import 'package:cvparser_b21_01/main_page.dart';
import 'colors.dart';

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
          primary: colorPrimaryRedCaramel,
          onPrimary: colorPrimaryRedCaramelDark,
          secondary: colorSecondaryGreenPlant,
          onSecondary: colorSecondaryLightGreenPlant,
          surface: colorSurfaceSmoothGreenPlant,
          onSurface: colorPrimaryLightRedCaramel,
          error: colorPrimaryLightRedCaramel,
          onError: colorPrimaryRedCaramel,
          background: colorSurfaceSmoothGreenPlant,
          onBackground: colorPrimaryLightRedCaramel,
        ),
        fontFamily: "Merriweather",
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              colorSecondaryLightGreenPlant,
            ),
          ),
        ),
      ),
      home: const MainPage(),
    );
  }
}
