import 'dart:convert';

import 'package:cvparser_b21_01/datatypes/all.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class IExtract extends GetxService {
  final _parseCvUrl =
      Uri.parse("https://aqueous-anchorage-93443.herokuapp.com/CvParser");

  Future<CVEntries> parseCV(String text) async {
    CVEntries parsedData = {};

    final Map data = {
      "text": text,
      "keywords": "string",
      "pattern": 11,
    };
    final body = json.encode(data);

    final response = await http.post(_parseCvUrl,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode != 200) {
      throw response;
    }

    final parsed = jsonDecode(response.body) as List<dynamic>;

    // group entries by label

    for (dynamic elem in parsed) {
      parsedData.putIfAbsent(elem["label"], () => []).add(
            CVMatch(
              match: elem["match"],
              sentence: elem["sentence"],
            ),
          );
    }

    return parsedData;
  }
}
