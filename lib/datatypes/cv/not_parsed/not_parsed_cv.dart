import 'package:cvparser_b21_01/datatypes/cv/parsed/parsed_cv.dart';

import '../cv_base.dart';

class NotParsedCV extends CVBase {
  NotParsedCV(filename) : super(filename);

  Future<ParsedCV> parse() async {
    throw UnimplementedError();
  }
}
