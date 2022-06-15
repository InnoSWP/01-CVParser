import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

// TODO
class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 505,
      height: 100,
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 400,
        height: 80,
        child: Row(
          children: [
            Column(children: const [
              Text(
                'Konstantin Fedorov',
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.5,
                  fontSize: 42,
                  fontFamily: "Eczar",
                  fontWeight: FontWeight.w400,
                  color: colorTextSmoothBlack,
                ),
              ),
              Text(
                'k.fedorov@innopolis.university   +79221994815',
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 0.2,
                  fontSize: 20,
                  fontFamily: "Eczar",
                  fontWeight: FontWeight.w400,
                  color: colorTextSmoothBlack,
                ),
              ),
            ]),
            const Icon(
              Icons.account_circle,
              size: 60,
              color: colorPrimaryRedCaramelDark,
            )
          ],
        ),
      ),
    );
  }
}
