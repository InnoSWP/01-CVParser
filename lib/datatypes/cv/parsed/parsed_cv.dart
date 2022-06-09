import '../cv_base.dart';
import 'cv_entries.dart';

/// Use this datatype to represent iExtract CV parse result
/// both with assigning it to the filename from where data was taken.
class ParsedCV extends CVBase {
  final CVEntries data;

  ParsedCV({
    required filename,
    required this.data,
  }) : super(filename);
}
