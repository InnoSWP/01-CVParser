import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'iExtract',
            style: TextStyle(
              fontSize: 80,
              fontFamily: 'Eczar',
              fontWeight: FontWeight.w600,
              color: colorPrimaryRedCaramelDark,
              height: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
