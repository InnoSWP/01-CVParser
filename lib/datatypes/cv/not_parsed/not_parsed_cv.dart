import '../cv_base.dart';
import '../parsed/parsed_cv.dart';

class NotParsedCV extends CVBase {
  NotParsedCV(filename) : super(filename);

  Future<ParsedCV> parse() async {
    throw UnimplementedError();
  }
}
