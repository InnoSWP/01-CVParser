// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'cv_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CVMatch _$CVMatchFromJson(Map<String, dynamic> json) {
  return _CVMatch.fromJson(json);
}

/// @nodoc
mixin _$CVMatch {
  String get match => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get sentence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CVMatchCopyWith<CVMatch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CVMatchCopyWith<$Res> {
  factory $CVMatchCopyWith(CVMatch value, $Res Function(CVMatch) then) =
      _$CVMatchCopyWithImpl<$Res>;
  $Res call({String match, String label, String sentence});
}

/// @nodoc
class _$CVMatchCopyWithImpl<$Res> implements $CVMatchCopyWith<$Res> {
  _$CVMatchCopyWithImpl(this._value, this._then);

  final CVMatch _value;
  // ignore: unused_field
  final $Res Function(CVMatch) _then;

  @override
  $Res call({
    Object? match = freezed,
    Object? label = freezed,
    Object? sentence = freezed,
  }) {
    return _then(_value.copyWith(
      match: match == freezed
          ? _value.match
          : match // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      sentence: sentence == freezed
          ? _value.sentence
          : sentence // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_CVMatchCopyWith<$Res> implements $CVMatchCopyWith<$Res> {
  factory _$$_CVMatchCopyWith(
          _$_CVMatch value, $Res Function(_$_CVMatch) then) =
      __$$_CVMatchCopyWithImpl<$Res>;
  @override
  $Res call({String match, String label, String sentence});
}

/// @nodoc
class __$$_CVMatchCopyWithImpl<$Res> extends _$CVMatchCopyWithImpl<$Res>
    implements _$$_CVMatchCopyWith<$Res> {
  __$$_CVMatchCopyWithImpl(_$_CVMatch _value, $Res Function(_$_CVMatch) _then)
      : super(_value, (v) => _then(v as _$_CVMatch));

  @override
  _$_CVMatch get _value => super._value as _$_CVMatch;

  @override
  $Res call({
    Object? match = freezed,
    Object? label = freezed,
    Object? sentence = freezed,
  }) {
    return _then(_$_CVMatch(
      match: match == freezed
          ? _value.match
          : match // ignore: cast_nullable_to_non_nullable
              as String,
      label: label == freezed
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      sentence: sentence == freezed
          ? _value.sentence
          : sentence // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CVMatch implements _CVMatch {
  const _$_CVMatch(
      {required this.match, required this.label, required this.sentence});

  factory _$_CVMatch.fromJson(Map<String, dynamic> json) =>
      _$$_CVMatchFromJson(json);

  @override
  final String match;
  @override
  final String label;
  @override
  final String sentence;

  @override
  String toString() {
    return 'CVMatch(match: $match, label: $label, sentence: $sentence)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CVMatch &&
            const DeepCollectionEquality().equals(other.match, match) &&
            const DeepCollectionEquality().equals(other.label, label) &&
            const DeepCollectionEquality().equals(other.sentence, sentence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(match),
      const DeepCollectionEquality().hash(label),
      const DeepCollectionEquality().hash(sentence));

  @JsonKey(ignore: true)
  @override
  _$$_CVMatchCopyWith<_$_CVMatch> get copyWith =>
      __$$_CVMatchCopyWithImpl<_$_CVMatch>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CVMatchToJson(this);
  }
}

abstract class _CVMatch implements CVMatch {
  const factory _CVMatch(
      {required final String match,
      required final String label,
      required final String sentence}) = _$_CVMatch;

  factory _CVMatch.fromJson(Map<String, dynamic> json) = _$_CVMatch.fromJson;

  @override
  String get match => throw _privateConstructorUsedError;
  @override
  String get label => throw _privateConstructorUsedError;
  @override
  String get sentence => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_CVMatchCopyWith<_$_CVMatch> get copyWith =>
      throw _privateConstructorUsedError;
}
