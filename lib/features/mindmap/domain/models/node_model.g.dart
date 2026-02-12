// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TextSpanDataImpl _$$TextSpanDataImplFromJson(Map<String, dynamic> json) =>
    _$TextSpanDataImpl(
      text: json['text'] as String,
      isBold: json['isBold'] as bool? ?? false,
    );

Map<String, dynamic> _$$TextSpanDataImplToJson(_$TextSpanDataImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'isBold': instance.isBold,
    };

_$NodeModelImpl _$$NodeModelImplFromJson(Map<String, dynamic> json) =>
    _$NodeModelImpl(
      id: json['id'] as String,
      mindmapId: json['mindmapId'] as String,
      text: json['text'] as String? ?? 'Neuer Knoten',
      notes: json['notes'] as String? ?? '',
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num?)?.toDouble() ?? 160.0,
      height: (json['height'] as num?)?.toDouble() ?? 80.0,
      color: (json['color'] as num?)?.toInt() ?? 0xFF4A6CF7,
      shape: $enumDecodeNullable(_$NodeShapeEnumMap, json['shape']) ??
          NodeShape.roundedRectangle,
      isBold: json['isBold'] as bool? ?? false,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 15.0,
      textSpans: (json['textSpans'] as List<dynamic>?)
              ?.map((e) => TextSpanData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String? ?? '',
      createdBy: json['createdBy'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$NodeModelImplToJson(_$NodeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mindmapId': instance.mindmapId,
      'text': instance.text,
      'notes': instance.notes,
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'color': instance.color,
      'shape': _$NodeShapeEnumMap[instance.shape]!,
      'isBold': instance.isBold,
      'fontSize': instance.fontSize,
      'textSpans': instance.textSpans,
      'imageUrl': instance.imageUrl,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$NodeShapeEnumMap = {
  NodeShape.circle: 'circle',
  NodeShape.rectangle: 'rectangle',
  NodeShape.roundedRectangle: 'roundedRectangle',
};
