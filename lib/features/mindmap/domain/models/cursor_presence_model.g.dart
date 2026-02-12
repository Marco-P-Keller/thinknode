// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cursor_presence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CursorPresenceModelImpl _$$CursorPresenceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CursorPresenceModelImpl(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      color: (json['color'] as num).toInt(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      lastSeen: const TimestampConverter().fromJson(json['lastSeen']),
    );

Map<String, dynamic> _$$CursorPresenceModelImplToJson(
        _$CursorPresenceModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'color': instance.color,
      'x': instance.x,
      'y': instance.y,
      'lastSeen': const TimestampConverter().toJson(instance.lastSeen),
    };
