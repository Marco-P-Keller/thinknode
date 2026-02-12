import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thinknode/core/utils/timestamp_converter.dart';
import 'package:thinknode/features/mindmap/domain/models/node_model.dart';
import 'package:thinknode/features/mindmap/domain/models/edge_model.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
class VersionModel with _$VersionModel {
  const factory VersionModel({
    required String id,
    required String mindmapId,
    required String description,
    required List<NodeModel> nodes,
    required List<EdgeModel> edges,
    required String createdBy,
    required String createdByName,
    @TimestampConverter() required DateTime createdAt,
  }) = _VersionModel;

  factory VersionModel.fromJson(Map<String, dynamic> json) =>
      _$VersionModelFromJson(json);
}

