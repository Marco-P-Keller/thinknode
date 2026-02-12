import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thinknode/core/utils/timestamp_converter.dart';

part 'mindmap_model.freezed.dart';
part 'mindmap_model.g.dart';

/// Roles for mindmap collaboration
enum MindMapRole {
  @JsonValue('owner')
  owner,
  @JsonValue('editor')
  editor,
  @JsonValue('viewer')
  viewer,
}

@freezed
class MindMapModel with _$MindMapModel {
  const factory MindMapModel({
    required String id,
    required String title,
    @Default('') String description,
    required String ownerId,
    required String ownerName,
    /// Map of userId -> role (as string: 'owner', 'editor', 'viewer')
    @Default(<String, String>{}) Map<String, String> collaborators,
    @Default(<String>[]) List<String> tags,
    @Default(false) bool isTemplate,
    @Default('') String thumbnail,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _MindMapModel;

  factory MindMapModel.fromJson(Map<String, dynamic> json) =>
      _$MindMapModelFromJson(json);
}

