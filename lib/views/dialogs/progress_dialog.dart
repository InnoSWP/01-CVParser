import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class ProgressDone {
  final double? percentage; // 0 - 1
  final String comments;
  ProgressDone(this.percentage, this.comments);
}

class ProgressDialog extends StatelessWidget {
  final String titleText;
  final Stream<ProgressDone> progressStream;

  const ProgressDialog({
    Key? key,
    required this.titleText,
    required this.progressStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: progressStream,
      builder: (context, snapshot) {
        final data = snapshot.data as ProgressDone;
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
                  Center(
                    child: CircularProgressIndicator(
                      value: data.percentage,
                    ),
                  ),
                  Text(
                    data.comments, // TODO: big comments trim
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
      },
    );
  }
}
