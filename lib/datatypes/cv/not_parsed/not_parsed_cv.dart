import '../cv_base.dart';
import '../parsed/parsed_cv.dart';

class NotParsedCV extends CVBase {
  NotParsedCV(filename) : super(filename);

  bool isParseCached() {
    throw UnimplementedError();
  }

  bool isParseCachedComplete() {
    throw UnimplementedError();
  }

  Future<ParsedCV> parse({bool mock = false}) async {
    throw UnimplementedError();
  }
}
