import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

// TODO
class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 100,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                Text(
                  'Konstantin Fedorov',
                  style: TextStyle(
                    height: 1.5,
                    fontSize: MediaQuery.of(context).size.width / 30,
                    fontFamily: "Eczar",
                    fontWeight: FontWeight.w400,
                    color: colorTextSmoothBlack,
                  ),
                ),
                Text(
                  'k.fedorov@innopolis.university  +79221994815',
                  style: TextStyle(
                    height: 1,
                    fontSize: MediaQuery.of(context).size.width / 73,
                    fontFamily: "Eczar",
                    fontWeight: FontWeight.w400,
                    color: colorTextSmoothBlack,
                  ),
                ),
              ])),
          if (MediaQuery.of(context).size.width > 1340)
            const Icon(Icons.account_circle,
                size: 60, color: colorPrimaryRedCaramelDark)
        ],
      ),
    ));
  }
}
