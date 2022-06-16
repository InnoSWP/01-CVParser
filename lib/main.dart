import 'package:cvparser_b21_01/bindings/initial_page_binding.dart';
import 'package:cvparser_b21_01/bindings/main_page_binding.dart';
import 'package:cvparser_b21_01/bindings/services_binding.dart';
import 'package:cvparser_b21_01/views/initial_page.dart';
import 'package:cvparser_b21_01/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    return GetMaterialApp(
      title: "CV Parser",
      theme: mainTheme,
      initialBinding: ServicesBinding(),
      initialRoute: "/initial",
      getPages: [
        GetPage(
          name: "/initial",
          page: () => const InitialPage(),
          bindings: [
            InitialPageBinding(),
          ],
        ),
        GetPage(
          name: "/main",
          page: () => const MainPage(),
          bindings: [
            MainPageBinding(),
          ],
        ),
      ],
    );
  }
}
