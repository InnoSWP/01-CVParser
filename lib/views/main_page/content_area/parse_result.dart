import 'package:cvparser_b21_01/views/common/card_widget.dart';
import 'package:flutter/material.dart';

class ParseResult extends StatelessWidget {
  const ParseResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          children: [
        'Skills',
        'Organization',
        'Language',
        'Countries',
        'Publication',
        'Links'
      ].map((country) {
        return CardWidget(title: country);
      }).toList()),
    );
  }
}
