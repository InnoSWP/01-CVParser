import 'dart:convert';

import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class IExtract extends GetxService {
  final _parseCvUrl =
      Uri.parse("https://aqueous-anchorage-93443.herokuapp.com/CvParser");

  final _mockParseCvUrl =
      Uri.parse("https://mock-cv-parser-3.herokuapp.com/api/cv_parser/");

  /// We cannot use autogenerated fromJson for [CVEntries]
  /// as iExtract API data format is in a little bit another manner.
  /// e.g
  /// iExtract response example:
  /// {
  ///   {
  ///     "label": "Skills",
  ///     "match": "C++",
  ///     "sentence": "I love C++"
  ///   }
  ///   {
  ///     "label": "Skills",
  ///     "match": "Java",
  ///     "sentence": "I had an experience in Java"
  ///   }
  ///   {
  ///     "label": "Language",
  ///     "match": "Eng",
  ///     "sentence": "B2 english"
  ///   }
  /// }
  /// how we need to group it to store as [CVEntries]:
  /// {
  ///   "Skills": [
  ///     {"match": "C++", "sentence": "I love C++"},
  ///     {"match": "Java", "sentence": "I had an experience in Java"}
  ///   ],
  ///   "Language": [
  ///     {"match": "Eng", "sentence": "B2 english"}
  ///   ]
  /// }
  /// so we need to write the convertion here manually
  Future<CVEntries> parseCV(String text, {bool mock = false}) async {
    CVEntries parsedData = {};

    final Map data = {
      "text": text,
      "keywords": "string",
      "pattern": 11,
    };
    final body = json.encode(data);

    final response = await http.post(mock ? _mockParseCvUrl : _parseCvUrl,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode != 200) {
      throw response;
    }

    final parsed = jsonDecode(response.body) as List<dynamic>;

    // group entries by label
    // (see the reasoning in the docstring of this method)
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
