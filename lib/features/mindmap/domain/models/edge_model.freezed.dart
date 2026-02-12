// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EdgeModel _$EdgeModelFromJson(Map<String, dynamic> json) {
  return _EdgeModel.fromJson(json);
}

/// @nodoc
mixin _$EdgeModel {
  String get id => throw _privateConstructorUsedError;
  String get mindmapId => throw _privateConstructorUsedError;
  String get sourceNodeId => throw _privateConstructorUsedError;
  String get targetNodeId => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  EdgeType get type => throw _privateConstructorUsedError;
  EdgeStyle get style => throw _privateConstructorUsedError;
  ArrowMode get arrowMode => throw _privateConstructorUsedError;

  /// Color stored as int value
  int get color => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EdgeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EdgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EdgeModelCopyWith<EdgeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EdgeModelCopyWith<$Res> {
  factory $EdgeModelCopyWith(EdgeModel value, $Res Function(EdgeModel) then) =
      _$EdgeModelCopyWithImpl<$Res, EdgeModel>;
  @useResult
  $Res call(
      {String id,
      String mindmapId,
      String sourceNodeId,
      String targetNodeId,
      String label,
      EdgeType type,
      EdgeStyle style,
      ArrowMode arrowMode,
      int color,
      String createdBy,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$EdgeModelCopyWithImpl<$Res, $Val extends EdgeModel>
    implements $EdgeModelCopyWith<$Res> {
  _$EdgeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EdgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mindmapId = null,
    Object? sourceNodeId = null,
    Object? targetNodeId = null,
    Object? label = null,
    Object? type = null,
    Object? style = null,
    Object? arrowMode = null,
    Object? color = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mindmapId: null == mindmapId
          ? _value.mindmapId
          : mindmapId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceNodeId: null == sourceNodeId
          ? _value.sourceNodeId
          : sourceNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      targetNodeId: null == targetNodeId
          ? _value.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EdgeType,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as EdgeStyle,
      arrowMode: null == arrowMode
          ? _value.arrowMode
          : arrowMode // ignore: cast_nullable_to_non_nullable
              as ArrowMode,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EdgeModelImplCopyWith<$Res>
    implements $EdgeModelCopyWith<$Res> {
  factory _$$EdgeModelImplCopyWith(
          _$EdgeModelImpl value, $Res Function(_$EdgeModelImpl) then) =
      __$$EdgeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String mindmapId,
      String sourceNodeId,
      String targetNodeId,
      String label,
      EdgeType type,
      EdgeStyle style,
      ArrowMode arrowMode,
      int color,
      String createdBy,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$EdgeModelImplCopyWithImpl<$Res>
    extends _$EdgeModelCopyWithImpl<$Res, _$EdgeModelImpl>
    implements _$$EdgeModelImplCopyWith<$Res> {
  __$$EdgeModelImplCopyWithImpl(
      _$EdgeModelImpl _value, $Res Function(_$EdgeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EdgeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mindmapId = null,
    Object? sourceNodeId = null,
    Object? targetNodeId = null,
    Object? label = null,
    Object? type = null,
    Object? style = null,
    Object? arrowMode = null,
    Object? color = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$EdgeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mindmapId: null == mindmapId
          ? _value.mindmapId
          : mindmapId // ignore: cast_nullable_to_non_nullable
              as String,
      sourceNodeId: null == sourceNodeId
          ? _value.sourceNodeId
          : sourceNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      targetNodeId: null == targetNodeId
          ? _value.targetNodeId
          : targetNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EdgeType,
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as EdgeStyle,
      arrowMode: null == arrowMode
          ? _value.arrowMode
          : arrowMode // ignore: cast_nullable_to_non_nullable
              as ArrowMode,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EdgeModelImpl implements _EdgeModel {
  const _$EdgeModelImpl(
      {required this.id,
      required this.mindmapId,
      required this.sourceNodeId,
      required this.targetNodeId,
      this.label = '',
      this.type = EdgeType.simple,
      this.style = EdgeStyle.curved,
      this.arrowMode = ArrowMode.forward,
      this.color = 0xFF607D8B,
      required this.createdBy,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt});

  factory _$EdgeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EdgeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String mindmapId;
  @override
  final String sourceNodeId;
  @override
  final String targetNodeId;
  @override
  @JsonKey()
  final String label;
  @override
  @JsonKey()
  final EdgeType type;
  @override
  @JsonKey()
  final EdgeStyle style;
  @override
  @JsonKey()
  final ArrowMode arrowMode;

  /// Color stored as int value
  @override
  @JsonKey()
  final int color;
  @override
  final String createdBy;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'EdgeModel(id: $id, mindmapId: $mindmapId, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId, label: $label, type: $type, style: $style, arrowMode: $arrowMode, color: $color, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EdgeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mindmapId, mindmapId) ||
                other.mindmapId == mindmapId) &&
            (identical(other.sourceNodeId, sourceNodeId) ||
                other.sourceNodeId == sourceNodeId) &&
            (identical(other.targetNodeId, targetNodeId) ||
                other.targetNodeId == targetNodeId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.arrowMode, arrowMode) ||
                other.arrowMode == arrowMode) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      mindmapId,
      sourceNodeId,
      targetNodeId,
      label,
      type,
      style,
      arrowMode,
      color,
      createdBy,
      createdAt,
      updatedAt);

  /// Create a copy of EdgeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EdgeModelImplCopyWith<_$EdgeModelImpl> get copyWith =>
      __$$EdgeModelImplCopyWithImpl<_$EdgeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EdgeModelImplToJson(
      this,
    );
  }
}

abstract class _EdgeModel implements EdgeModel {
  const factory _EdgeModel(
          {required final String id,
          required final String mindmapId,
          required final String sourceNodeId,
          required final String targetNodeId,
          final String label,
          final EdgeType type,
          final EdgeStyle style,
          final ArrowMode arrowMode,
          final int color,
          required final String createdBy,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$EdgeModelImpl;

  factory _EdgeModel.fromJson(Map<String, dynamic> json) =
      _$EdgeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get mindmapId;
  @override
  String get sourceNodeId;
  @override
  String get targetNodeId;
  @override
  String get label;
  @override
  EdgeType get type;
  @override
  EdgeStyle get style;
  @override
  ArrowMode get arrowMode;

  /// Color stored as int value
  @override
  int get color;
  @override
  String get createdBy;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of EdgeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EdgeModelImplCopyWith<_$EdgeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
