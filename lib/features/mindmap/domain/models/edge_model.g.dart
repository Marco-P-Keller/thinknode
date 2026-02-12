// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EdgeModelImpl _$$EdgeModelImplFromJson(Map<String, dynamic> json) =>
    _$EdgeModelImpl(
      id: json['id'] as String,
      mindmapId: json['mindmapId'] as String,
      sourceNodeId: json['sourceNodeId'] as String,
      targetNodeId: json['targetNodeId'] as String,
      label: json['label'] as String? ?? '',
      type: $enumDecodeNullable(_$EdgeTypeEnumMap, json['type']) ??
          EdgeType.simple,
      style: $enumDecodeNullable(_$EdgeStyleEnumMap, json['style']) ??
          EdgeStyle.curved,
      arrowMode: $enumDecodeNullable(_$ArrowModeEnumMap, json['arrowMode']) ??
          ArrowMode.forward,
      color: (json['color'] as num?)?.toInt() ?? 0xFF607D8B,
      createdBy: json['createdBy'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$EdgeModelImplToJson(_$EdgeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mindmapId': instance.mindmapId,
      'sourceNodeId': instance.sourceNodeId,
      'targetNodeId': instance.targetNodeId,
      'label': instance.label,
      'type': _$EdgeTypeEnumMap[instance.type]!,
      'style': _$EdgeStyleEnumMap[instance.style]!,
      'arrowMode': _$ArrowModeEnumMap[instance.arrowMode]!,
      'color': instance.color,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$EdgeTypeEnumMap = {
  EdgeType.simple: 'simple',
  EdgeType.double: 'double',
  EdgeType.dashed: 'dashed',
};

const _$EdgeStyleEnumMap = {
  EdgeStyle.straight: 'straight',
  EdgeStyle.curved: 'curved',
};

const _$ArrowModeEnumMap = {
  ArrowMode.forward: 'forward',
  ArrowMode.backward: 'backward',
  ArrowMode.both: 'both',
  ArrowMode.none: 'none',
};
