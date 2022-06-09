import '../cv_base.dart';
import 'cv_match.dart';

/// Use this datatype to represent iExtract CV parse result
/// both with assigning it to the filename from where data was taken.
///
/// Note: [data] field is supposed to hold result from parsing json like this:
/// {
///   "Skills": [
///     {"match": "C++", "sentence": "I love C++"},
///     {"match": "Java", "sentence": "I had an experience in Java"}
///   ],
///   "Language": [
///     {"match": "Eng", "sentence": "B2 english"}
///   ]
/// }
///
class ParsedCV extends CVBase {
  final Map<String, List<CVMatch>> data;

  ParsedCV({
    required filename,
    required this.data,
  }) : super(filename);
}
