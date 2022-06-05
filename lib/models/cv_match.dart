import 'package:freezed_annotation/freezed_annotation.dart';

part 'cv_match.freezed.dart';
part 'cv_match.g.dart';

@freezed
class CVMatch with _$CVMatch {
  const factory CVMatch({
    required String match,
    required String label,
    required String sentence,
  }) = _CVMatch;

  factory CVMatch.fromJson(Map<String, Object?> json) =>
      _$CVMatchFromJson(json);
}
