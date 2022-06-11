import 'package:flutter/material.dart';

import 'package:cvparser_b21_01/colors.dart';

class CardWidget extends StatefulWidget {
  final String title;

  // right now it only accepts title, but you can add more
  // arguments to be accepted by this widget
  const CardWidget({Key? key, required this.title}) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  // responsible for toggle
  bool _showData = false;
  bool aboba = true;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10.0),
          // list card containing country name
          GestureDetector(
              onTap: () {
                setState(() {
                  _showData = !_showData;
                  aboba = !aboba;
                });
              },
              child: Container(
                  width: 900,
                  height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.title,
                                style: const TextStyle(
                                    fontSize: 60,
                                    fontFamily: "Eczar",
                                    fontWeight: FontWeight.w400,
                                    color: colorTextSmoothBlack)),
                            if (aboba)
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 55, color: colorSecondaryGreenPlant)
                            else
                              const Icon(Icons.keyboard_arrow_up_rounded,
                                  size: 55, color: colorSecondaryGreenPlant)
                          ])))),

          // this is the company card which is toggling based upon the bool
          _showData
              ? Container(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        'Java',
                        'Python',
                        'C++',
                        'Web Development',
                        'AWS',
                        'FPGA'
                      ].map((e) {
                        // make changes in the UI here for your company card
                        return Card(
                            child: Text(e,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Merriweather',
                                    color: colorTextSmoothBlack)));
                      }).toList()))
              : const SizedBox() // else blank
        ]);
  }
}
