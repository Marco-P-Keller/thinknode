// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cursor_presence_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CursorPresenceModel _$CursorPresenceModelFromJson(Map<String, dynamic> json) {
  return _CursorPresenceModel.fromJson(json);
}

/// @nodoc
mixin _$CursorPresenceModel {
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

  /// Color stored as int value
  int get color => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get lastSeen => throw _privateConstructorUsedError;

  /// Serializes this CursorPresenceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CursorPresenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CursorPresenceModelCopyWith<CursorPresenceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CursorPresenceModelCopyWith<$Res> {
  factory $CursorPresenceModelCopyWith(
          CursorPresenceModel value, $Res Function(CursorPresenceModel) then) =
      _$CursorPresenceModelCopyWithImpl<$Res, CursorPresenceModel>;
  @useResult
  $Res call(
      {String userId,
      String displayName,
      int color,
      double x,
      double y,
      @TimestampConverter() DateTime lastSeen});
}

/// @nodoc
class _$CursorPresenceModelCopyWithImpl<$Res, $Val extends CursorPresenceModel>
    implements $CursorPresenceModelCopyWith<$Res> {
  _$CursorPresenceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CursorPresenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? color = null,
    Object? x = null,
    Object? y = null,
    Object? lastSeen = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CursorPresenceModelImplCopyWith<$Res>
    implements $CursorPresenceModelCopyWith<$Res> {
  factory _$$CursorPresenceModelImplCopyWith(_$CursorPresenceModelImpl value,
          $Res Function(_$CursorPresenceModelImpl) then) =
      __$$CursorPresenceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String displayName,
      int color,
      double x,
      double y,
      @TimestampConverter() DateTime lastSeen});
}

/// @nodoc
class __$$CursorPresenceModelImplCopyWithImpl<$Res>
    extends _$CursorPresenceModelCopyWithImpl<$Res, _$CursorPresenceModelImpl>
    implements _$$CursorPresenceModelImplCopyWith<$Res> {
  __$$CursorPresenceModelImplCopyWithImpl(_$CursorPresenceModelImpl _value,
      $Res Function(_$CursorPresenceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CursorPresenceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = null,
    Object? color = null,
    Object? x = null,
    Object? y = null,
    Object? lastSeen = null,
  }) {
    return _then(_$CursorPresenceModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      lastSeen: null == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CursorPresenceModelImpl implements _CursorPresenceModel {
  const _$CursorPresenceModelImpl(
      {required this.userId,
      required this.displayName,
      required this.color,
      required this.x,
      required this.y,
      @TimestampConverter() required this.lastSeen});

  factory _$CursorPresenceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CursorPresenceModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String displayName;

  /// Color stored as int value
  @override
  final int color;
  @override
  final double x;
  @override
  final double y;
  @override
  @TimestampConverter()
  final DateTime lastSeen;

  @override
  String toString() {
    return 'CursorPresenceModel(userId: $userId, displayName: $displayName, color: $color, x: $x, y: $y, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CursorPresenceModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, displayName, color, x, y, lastSeen);

  /// Create a copy of CursorPresenceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CursorPresenceModelImplCopyWith<_$CursorPresenceModelImpl> get copyWith =>
      __$$CursorPresenceModelImplCopyWithImpl<_$CursorPresenceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CursorPresenceModelImplToJson(
      this,
    );
  }
}

abstract class _CursorPresenceModel implements CursorPresenceModel {
  const factory _CursorPresenceModel(
          {required final String userId,
          required final String displayName,
          required final int color,
          required final double x,
          required final double y,
          @TimestampConverter() required final DateTime lastSeen}) =
      _$CursorPresenceModelImpl;

  factory _CursorPresenceModel.fromJson(Map<String, dynamic> json) =
      _$CursorPresenceModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get displayName;

  /// Color stored as int value
  @override
  int get color;
  @override
  double get x;
  @override
  double get y;
  @override
  @TimestampConverter()
  DateTime get lastSeen;

  /// Create a copy of CursorPresenceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CursorPresenceModelImplCopyWith<_$CursorPresenceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
