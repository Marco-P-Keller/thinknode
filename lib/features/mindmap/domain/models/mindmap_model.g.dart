// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mindmap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MindMapModelImpl _$$MindMapModelImplFromJson(Map<String, dynamic> json) =>
    _$MindMapModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      collaborators: (json['collaborators'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      isTemplate: json['isTemplate'] as bool? ?? false,
      thumbnail: json['thumbnail'] as String? ?? '',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$MindMapModelImplToJson(_$MindMapModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'collaborators': instance.collaborators,
      'tags': instance.tags,
      'isTemplate': instance.isTemplate,
      'thumbnail': instance.thumbnail,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
