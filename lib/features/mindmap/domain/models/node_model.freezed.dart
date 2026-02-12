// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TextSpanData _$TextSpanDataFromJson(Map<String, dynamic> json) {
  return _TextSpanData.fromJson(json);
}

/// @nodoc
mixin _$TextSpanData {
  String get text => throw _privateConstructorUsedError;
  bool get isBold => throw _privateConstructorUsedError;

  /// Serializes this TextSpanData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TextSpanData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextSpanDataCopyWith<TextSpanData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextSpanDataCopyWith<$Res> {
  factory $TextSpanDataCopyWith(
          TextSpanData value, $Res Function(TextSpanData) then) =
      _$TextSpanDataCopyWithImpl<$Res, TextSpanData>;
  @useResult
  $Res call({String text, bool isBold});
}

/// @nodoc
class _$TextSpanDataCopyWithImpl<$Res, $Val extends TextSpanData>
    implements $TextSpanDataCopyWith<$Res> {
  _$TextSpanDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextSpanData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? isBold = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isBold: null == isBold
          ? _value.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextSpanDataImplCopyWith<$Res>
    implements $TextSpanDataCopyWith<$Res> {
  factory _$$TextSpanDataImplCopyWith(
          _$TextSpanDataImpl value, $Res Function(_$TextSpanDataImpl) then) =
      __$$TextSpanDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, bool isBold});
}

/// @nodoc
class __$$TextSpanDataImplCopyWithImpl<$Res>
    extends _$TextSpanDataCopyWithImpl<$Res, _$TextSpanDataImpl>
    implements _$$TextSpanDataImplCopyWith<$Res> {
  __$$TextSpanDataImplCopyWithImpl(
      _$TextSpanDataImpl _value, $Res Function(_$TextSpanDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of TextSpanData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? isBold = null,
  }) {
    return _then(_$TextSpanDataImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isBold: null == isBold
          ? _value.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TextSpanDataImpl implements _TextSpanData {
  const _$TextSpanDataImpl({required this.text, this.isBold = false});

  factory _$TextSpanDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TextSpanDataImplFromJson(json);

  @override
  final String text;
  @override
  @JsonKey()
  final bool isBold;

  @override
  String toString() {
    return 'TextSpanData(text: $text, isBold: $isBold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextSpanDataImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isBold, isBold) || other.isBold == isBold));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, isBold);

  /// Create a copy of TextSpanData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextSpanDataImplCopyWith<_$TextSpanDataImpl> get copyWith =>
      __$$TextSpanDataImplCopyWithImpl<_$TextSpanDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TextSpanDataImplToJson(
      this,
    );
  }
}

abstract class _TextSpanData implements TextSpanData {
  const factory _TextSpanData({required final String text, final bool isBold}) =
      _$TextSpanDataImpl;

  factory _TextSpanData.fromJson(Map<String, dynamic> json) =
      _$TextSpanDataImpl.fromJson;

  @override
  String get text;
  @override
  bool get isBold;

  /// Create a copy of TextSpanData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextSpanDataImplCopyWith<_$TextSpanDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NodeModel _$NodeModelFromJson(Map<String, dynamic> json) {
  return _NodeModel.fromJson(json);
}

/// @nodoc
mixin _$NodeModel {
  String get id => throw _privateConstructorUsedError;
  String get mindmapId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;

  /// Color stored as int value (e.g. 0xFF4A6CF7)
  int get color => throw _privateConstructorUsedError;
  NodeShape get shape => throw _privateConstructorUsedError;
  bool get isBold => throw _privateConstructorUsedError;
  double get fontSize => throw _privateConstructorUsedError;

  /// Rich text formatting as list of spans
  List<TextSpanData> get textSpans => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this NodeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeModelCopyWith<NodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeModelCopyWith<$Res> {
  factory $NodeModelCopyWith(NodeModel value, $Res Function(NodeModel) then) =
      _$NodeModelCopyWithImpl<$Res, NodeModel>;
  @useResult
  $Res call(
      {String id,
      String mindmapId,
      String text,
      String notes,
      double x,
      double y,
      double width,
      double height,
      int color,
      NodeShape shape,
      bool isBold,
      double fontSize,
      List<TextSpanData> textSpans,
      String imageUrl,
      String createdBy,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$NodeModelCopyWithImpl<$Res, $Val extends NodeModel>
    implements $NodeModelCopyWith<$Res> {
  _$NodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mindmapId = null,
    Object? text = null,
    Object? notes = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? color = null,
    Object? shape = null,
    Object? isBold = null,
    Object? fontSize = null,
    Object? textSpans = null,
    Object? imageUrl = null,
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
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      shape: null == shape
          ? _value.shape
          : shape // ignore: cast_nullable_to_non_nullable
              as NodeShape,
      isBold: null == isBold
          ? _value.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      textSpans: null == textSpans
          ? _value.textSpans
          : textSpans // ignore: cast_nullable_to_non_nullable
              as List<TextSpanData>,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$NodeModelImplCopyWith<$Res>
    implements $NodeModelCopyWith<$Res> {
  factory _$$NodeModelImplCopyWith(
          _$NodeModelImpl value, $Res Function(_$NodeModelImpl) then) =
      __$$NodeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String mindmapId,
      String text,
      String notes,
      double x,
      double y,
      double width,
      double height,
      int color,
      NodeShape shape,
      bool isBold,
      double fontSize,
      List<TextSpanData> textSpans,
      String imageUrl,
      String createdBy,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$NodeModelImplCopyWithImpl<$Res>
    extends _$NodeModelCopyWithImpl<$Res, _$NodeModelImpl>
    implements _$$NodeModelImplCopyWith<$Res> {
  __$$NodeModelImplCopyWithImpl(
      _$NodeModelImpl _value, $Res Function(_$NodeModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mindmapId = null,
    Object? text = null,
    Object? notes = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? color = null,
    Object? shape = null,
    Object? isBold = null,
    Object? fontSize = null,
    Object? textSpans = null,
    Object? imageUrl = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NodeModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mindmapId: null == mindmapId
          ? _value.mindmapId
          : mindmapId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      shape: null == shape
          ? _value.shape
          : shape // ignore: cast_nullable_to_non_nullable
              as NodeShape,
      isBold: null == isBold
          ? _value.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      textSpans: null == textSpans
          ? _value._textSpans
          : textSpans // ignore: cast_nullable_to_non_nullable
              as List<TextSpanData>,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$NodeModelImpl implements _NodeModel {
  const _$NodeModelImpl(
      {required this.id,
      required this.mindmapId,
      this.text = 'Neuer Knoten',
      this.notes = '',
      required this.x,
      required this.y,
      this.width = 160.0,
      this.height = 80.0,
      this.color = 0xFF4A6CF7,
      this.shape = NodeShape.roundedRectangle,
      this.isBold = false,
      this.fontSize = 15.0,
      final List<TextSpanData> textSpans = const [],
      this.imageUrl = '',
      required this.createdBy,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt})
      : _textSpans = textSpans;

  factory _$NodeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NodeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String mindmapId;
  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String notes;
  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double height;

  /// Color stored as int value (e.g. 0xFF4A6CF7)
  @override
  @JsonKey()
  final int color;
  @override
  @JsonKey()
  final NodeShape shape;
  @override
  @JsonKey()
  final bool isBold;
  @override
  @JsonKey()
  final double fontSize;

  /// Rich text formatting as list of spans
  final List<TextSpanData> _textSpans;

  /// Rich text formatting as list of spans
  @override
  @JsonKey()
  List<TextSpanData> get textSpans {
    if (_textSpans is EqualUnmodifiableListView) return _textSpans;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_textSpans);
  }

  @override
  @JsonKey()
  final String imageUrl;
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
    return 'NodeModel(id: $id, mindmapId: $mindmapId, text: $text, notes: $notes, x: $x, y: $y, width: $width, height: $height, color: $color, shape: $shape, isBold: $isBold, fontSize: $fontSize, textSpans: $textSpans, imageUrl: $imageUrl, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mindmapId, mindmapId) ||
                other.mindmapId == mindmapId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.shape, shape) || other.shape == shape) &&
            (identical(other.isBold, isBold) || other.isBold == isBold) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            const DeepCollectionEquality()
                .equals(other._textSpans, _textSpans) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
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
      text,
      notes,
      x,
      y,
      width,
      height,
      color,
      shape,
      isBold,
      fontSize,
      const DeepCollectionEquality().hash(_textSpans),
      imageUrl,
      createdBy,
      createdAt,
      updatedAt);

  /// Create a copy of NodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeModelImplCopyWith<_$NodeModelImpl> get copyWith =>
      __$$NodeModelImplCopyWithImpl<_$NodeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NodeModelImplToJson(
      this,
    );
  }
}

abstract class _NodeModel implements NodeModel {
  const factory _NodeModel(
          {required final String id,
          required final String mindmapId,
          final String text,
          final String notes,
          required final double x,
          required final double y,
          final double width,
          final double height,
          final int color,
          final NodeShape shape,
          final bool isBold,
          final double fontSize,
          final List<TextSpanData> textSpans,
          final String imageUrl,
          required final String createdBy,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$NodeModelImpl;

  factory _NodeModel.fromJson(Map<String, dynamic> json) =
      _$NodeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get mindmapId;
  @override
  String get text;
  @override
  String get notes;
  @override
  double get x;
  @override
  double get y;
  @override
  double get width;
  @override
  double get height;

  /// Color stored as int value (e.g. 0xFF4A6CF7)
  @override
  int get color;
  @override
  NodeShape get shape;
  @override
  bool get isBold;
  @override
  double get fontSize;

  /// Rich text formatting as list of spans
  @override
  List<TextSpanData> get textSpans;
  @override
  String get imageUrl;
  @override
  String get createdBy;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of NodeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeModelImplCopyWith<_$NodeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
