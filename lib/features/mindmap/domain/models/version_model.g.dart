// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VersionModelImpl _$$VersionModelImplFromJson(Map<String, dynamic> json) =>
    _$VersionModelImpl(
      id: json['id'] as String,
      mindmapId: json['mindmapId'] as String,
      description: json['description'] as String,
      nodes: (json['nodes'] as List<dynamic>)
          .map((e) => NodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      edges: (json['edges'] as List<dynamic>)
          .map((e) => EdgeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdBy: json['createdBy'] as String,
      createdByName: json['createdByName'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$VersionModelImplToJson(_$VersionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mindmapId': instance.mindmapId,
      'description': instance.description,
      'nodes': instance.nodes,
      'edges': instance.edges,
      'createdBy': instance.createdBy,
      'createdByName': instance.createdByName,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
