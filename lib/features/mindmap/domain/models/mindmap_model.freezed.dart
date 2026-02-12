// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mindmap_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MindMapModel _$MindMapModelFromJson(Map<String, dynamic> json) {
  return _MindMapModel.fromJson(json);
}

/// @nodoc
mixin _$MindMapModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;

  /// Map of userId -> role (as string: 'owner', 'editor', 'viewer')
  Map<String, String> get collaborators => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isTemplate => throw _privateConstructorUsedError;
  String get thumbnail => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MindMapModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MindMapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MindMapModelCopyWith<MindMapModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MindMapModelCopyWith<$Res> {
  factory $MindMapModelCopyWith(
          MindMapModel value, $Res Function(MindMapModel) then) =
      _$MindMapModelCopyWithImpl<$Res, MindMapModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String ownerId,
      String ownerName,
      Map<String, String> collaborators,
      List<String> tags,
      bool isTemplate,
      String thumbnail,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$MindMapModelCopyWithImpl<$Res, $Val extends MindMapModel>
    implements $MindMapModelCopyWith<$Res> {
  _$MindMapModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MindMapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? collaborators = null,
    Object? tags = null,
    Object? isTemplate = null,
    Object? thumbnail = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      collaborators: null == collaborators
          ? _value.collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTemplate: null == isTemplate
          ? _value.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MindMapModelImplCopyWith<$Res>
    implements $MindMapModelCopyWith<$Res> {
  factory _$$MindMapModelImplCopyWith(
          _$MindMapModelImpl value, $Res Function(_$MindMapModelImpl) then) =
      __$$MindMapModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String ownerId,
      String ownerName,
      Map<String, String> collaborators,
      List<String> tags,
      bool isTemplate,
      String thumbnail,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$MindMapModelImplCopyWithImpl<$Res>
    extends _$MindMapModelCopyWithImpl<$Res, _$MindMapModelImpl>
    implements _$$MindMapModelImplCopyWith<$Res> {
  __$$MindMapModelImplCopyWithImpl(
      _$MindMapModelImpl _value, $Res Function(_$MindMapModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MindMapModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? ownerId = null,
    Object? ownerName = null,
    Object? collaborators = null,
    Object? tags = null,
    Object? isTemplate = null,
    Object? thumbnail = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$MindMapModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: null == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String,
      collaborators: null == collaborators
          ? _value._collaborators
          : collaborators // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isTemplate: null == isTemplate
          ? _value.isTemplate
          : isTemplate // ignore: cast_nullable_to_non_nullable
              as bool,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
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
class _$MindMapModelImpl implements _MindMapModel {
  const _$MindMapModelImpl(
      {required this.id,
      required this.title,
      this.description = '',
      required this.ownerId,
      required this.ownerName,
      final Map<String, String> collaborators = const <String, String>{},
      final List<String> tags = const <String>[],
      this.isTemplate = false,
      this.thumbnail = '',
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt})
      : _collaborators = collaborators,
        _tags = tags;

  factory _$MindMapModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MindMapModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  final String ownerId;
  @override
  final String ownerName;

  /// Map of userId -> role (as string: 'owner', 'editor', 'viewer')
  final Map<String, String> _collaborators;

  /// Map of userId -> role (as string: 'owner', 'editor', 'viewer')
  @override
  @JsonKey()
  Map<String, String> get collaborators {
    if (_collaborators is EqualUnmodifiableMapView) return _collaborators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_collaborators);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isTemplate;
  @override
  @JsonKey()
  final String thumbnail;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MindMapModel(id: $id, title: $title, description: $description, ownerId: $ownerId, ownerName: $ownerName, collaborators: $collaborators, tags: $tags, isTemplate: $isTemplate, thumbnail: $thumbnail, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MindMapModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            const DeepCollectionEquality()
                .equals(other._collaborators, _collaborators) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isTemplate, isTemplate) ||
                other.isTemplate == isTemplate) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
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
      title,
      description,
      ownerId,
      ownerName,
      const DeepCollectionEquality().hash(_collaborators),
      const DeepCollectionEquality().hash(_tags),
      isTemplate,
      thumbnail,
      createdAt,
      updatedAt);

  /// Create a copy of MindMapModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MindMapModelImplCopyWith<_$MindMapModelImpl> get copyWith =>
      __$$MindMapModelImplCopyWithImpl<_$MindMapModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MindMapModelImplToJson(
      this,
    );
  }
}

abstract class _MindMapModel implements MindMapModel {
  const factory _MindMapModel(
          {required final String id,
          required final String title,
          final String description,
          required final String ownerId,
          required final String ownerName,
          final Map<String, String> collaborators,
          final List<String> tags,
          final bool isTemplate,
          final String thumbnail,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$MindMapModelImpl;

  factory _MindMapModel.fromJson(Map<String, dynamic> json) =
      _$MindMapModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get ownerId;
  @override
  String get ownerName;

  /// Map of userId -> role (as string: 'owner', 'editor', 'viewer')
  @override
  Map<String, String> get collaborators;
  @override
  List<String> get tags;
  @override
  bool get isTemplate;
  @override
  String get thumbnail;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of MindMapModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MindMapModelImplCopyWith<_$MindMapModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
