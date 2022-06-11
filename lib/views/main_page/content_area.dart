import 'package:flutter/material.dart';

import 'content_area/contact.dart';
import 'content_area/footer.dart';
import 'content_area/logo.dart';
import 'content_area/parse_result.dart';

class ContentArea extends StatelessWidget {
  const ContentArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: const [Logo(), Contact()]),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
            child: const ParseResult(),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: const Footer(),
        )
      ],
    );
  }
}
