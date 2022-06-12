import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class FailDialog extends StatelessWidget {
  final String titleText;
  final String details;

  const FailDialog({
    Key? key,
    required this.titleText,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          height: 200, // TODO: adaptive card
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                titleText,
                style: const TextStyle(
                  fontSize: 30,
                  fontFamily: "Eczar",
                  fontWeight: FontWeight.w400,
                  color: colorTextSmoothBlack,
                ),
              ),
              Text(
                details, // TODO: big comments trim
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: colorTextSmoothBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
