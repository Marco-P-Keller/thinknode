import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thinknode/core/utils/timestamp_converter.dart';

part 'edge_model.freezed.dart';
part 'edge_model.g.dart';

/// Type of edge line
enum EdgeType {
  @JsonValue('simple')
  simple,
  @JsonValue('double')
  double,
  @JsonValue('dashed')
  dashed,
}

/// Style of edge path
enum EdgeStyle {
  @JsonValue('straight')
  straight,
  @JsonValue('curved')
  curved,
}

/// Arrow direction mode
enum ArrowMode {
  @JsonValue('forward')
  forward,    // Arrow at target (source → target)
  @JsonValue('backward')
  backward,   // Arrow at source (source ← target)
  @JsonValue('both')
  both,       // Arrow at both ends (source ↔ target)
  @JsonValue('none')
  none,       // No arrows
}

@freezed
class EdgeModel with _$EdgeModel {
  const factory EdgeModel({
    required String id,
    required String mindmapId,
    required String sourceNodeId,
    required String targetNodeId,
    @Default('') String label,
    @Default(EdgeType.simple) EdgeType type,
    @Default(EdgeStyle.curved) EdgeStyle style,
    @Default(ArrowMode.forward) ArrowMode arrowMode,
    /// Color stored as int value
    @Default(0xFF607D8B) int color,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EdgeModel;

  factory EdgeModel.fromJson(Map<String, dynamic> json) =>
      _$EdgeModelFromJson(json);
}

