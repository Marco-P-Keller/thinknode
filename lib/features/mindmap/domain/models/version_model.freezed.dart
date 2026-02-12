// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'version_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VersionModel _$VersionModelFromJson(Map<String, dynamic> json) {
  return _VersionModel.fromJson(json);
}

/// @nodoc
mixin _$VersionModel {
  String get id => throw _privateConstructorUsedError;
  String get mindmapId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<NodeModel> get nodes => throw _privateConstructorUsedError;
  List<EdgeModel> get edges => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdByName => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VersionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VersionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VersionModelCopyWith<VersionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VersionModelCopyWith<$Res> {
  factory $VersionModelCopyWith(
          VersionModel value, $Res Function(VersionModel) then) =
      _$VersionModelCopyWithImpl<$Res, VersionModel>;
  @useResult
  $Res call(
      {String id,
      String mindmapId,
      String description,
      List<NodeModel> nodes,
      List<EdgeModel> edges,
      String createdBy,
      String createdByName,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$VersionModelCopyWithImpl<$Res, $Val extends VersionModel>
    implements $VersionModelCopyWith<$Res> {
  _$VersionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VersionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mindmapId = null,
    Object? description = null,
    Object? nodes = null,
    Object? edges = null,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? createdAt = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<NodeModel>,
      edges: null == edges
          ? _value.edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<EdgeModel>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VersionModelImplCopyWith<$Res>
    implements $VersionModelCopyWith<$Res> {
  factory _$$VersionModelImplCopyWith(
          _$VersionModelImpl value, $Res Function(_$VersionModelImpl) then) =
      __$$VersionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String mindmapId,
      String description,
      List<NodeModel> nodes,
      List<EdgeModel> edges,
      String createdBy,
      String createdByName,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$$VersionModelImplCopyWithImpl<$Res>
    extends _$VersionModelCopyWithImpl<$Res, _$VersionModelImpl>
    implements _$$VersionModelImplCopyWith<$Res> {
  __$$VersionModelImplCopyWithImpl(
      _$VersionModelImpl _value, $Res Function(_$VersionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VersionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mindmapId = null,
    Object? description = null,
    Object? nodes = null,
    Object? edges = null,
    Object? createdBy = null,
    Object? createdByName = null,
    Object? createdAt = null,
  }) {
    return _then(_$VersionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      mindmapId: null == mindmapId
          ? _value.mindmapId
          : mindmapId // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<NodeModel>,
      edges: null == edges
          ? _value._edges
          : edges // ignore: cast_nullable_to_non_nullable
              as List<EdgeModel>,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdByName: null == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VersionModelImpl implements _VersionModel {
  const _$VersionModelImpl(
      {required this.id,
      required this.mindmapId,
      required this.description,
      required final List<NodeModel> nodes,
      required final List<EdgeModel> edges,
      required this.createdBy,
      required this.createdByName,
      @TimestampConverter() required this.createdAt})
      : _nodes = nodes,
        _edges = edges;

  factory _$VersionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VersionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String mindmapId;
  @override
  final String description;
  final List<NodeModel> _nodes;
  @override
  List<NodeModel> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  final List<EdgeModel> _edges;
  @override
  List<EdgeModel> get edges {
    if (_edges is EqualUnmodifiableListView) return _edges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_edges);
  }

  @override
  final String createdBy;
  @override
  final String createdByName;
  @override
  @TimestampConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'VersionModel(id: $id, mindmapId: $mindmapId, description: $description, nodes: $nodes, edges: $edges, createdBy: $createdBy, createdByName: $createdByName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VersionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mindmapId, mindmapId) ||
                other.mindmapId == mindmapId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            const DeepCollectionEquality().equals(other._edges, _edges) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      mindmapId,
      description,
      const DeepCollectionEquality().hash(_nodes),
      const DeepCollectionEquality().hash(_edges),
      createdBy,
      createdByName,
      createdAt);

  /// Create a copy of VersionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VersionModelImplCopyWith<_$VersionModelImpl> get copyWith =>
      __$$VersionModelImplCopyWithImpl<_$VersionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VersionModelImplToJson(
      this,
    );
  }
}

abstract class _VersionModel implements VersionModel {
  const factory _VersionModel(
          {required final String id,
          required final String mindmapId,
          required final String description,
          required final List<NodeModel> nodes,
          required final List<EdgeModel> edges,
          required final String createdBy,
          required final String createdByName,
          @TimestampConverter() required final DateTime createdAt}) =
      _$VersionModelImpl;

  factory _VersionModel.fromJson(Map<String, dynamic> json) =
      _$VersionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get mindmapId;
  @override
  String get description;
  @override
  List<NodeModel> get nodes;
  @override
  List<EdgeModel> get edges;
  @override
  String get createdBy;
  @override
  String get createdByName;
  @override
  @TimestampConverter()
  DateTime get createdAt;

  /// Create a copy of VersionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VersionModelImplCopyWith<_$VersionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
