import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// TODO
class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: SizedBox(
            width: (MediaQuery.of(context).size.width > 1400) ? 505 : 370,
            height: 120,
            child: Row(
              children: [
                Container(
                  width: 370,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Konstantin Fedorov',
                          style: TextStyle(
                            height: 1,
                            fontSize: 40,
                            fontFamily: "Eczar",
                            fontWeight: FontWeight.w400,
                            color: colorTextSmoothBlack,
                          ),
                        ),
                        Text(
                          'k.fedorov@innopolis.university\n+79221994815',
                          style: TextStyle(
                            height: 1,
                            fontSize: 18,
                            fontFamily: "Eczar",
                            fontWeight: FontWeight.w400,
                            color: colorTextSmoothBlack,
                          ),
                        ),
                      ]),
                ),
                if (MediaQuery.of(context).size.width > 1400)
                  const SizedBox(width: 25, height: 110),
                if (MediaQuery.of(context).size.width > 1400)
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.account_circle_outlined,
                        size: 80, color: Theme.of(context).colorScheme.primary),
                  ),
              ],
            )
        )
    );
  }
}
