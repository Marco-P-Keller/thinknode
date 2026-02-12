import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thinknode/core/utils/timestamp_converter.dart';

part 'node_model.freezed.dart';
part 'node_model.g.dart';

/// Possible shapes for a node
enum NodeShape {
  @JsonValue('circle')
  circle,
  @JsonValue('rectangle')
  rectangle,
  @JsonValue('roundedRectangle')
  roundedRectangle,
}

/// A text span with formatting
@freezed
class TextSpanData with _$TextSpanData {
  const factory TextSpanData({
    required String text,
    @Default(false) bool isBold,
  }) = _TextSpanData;

  factory TextSpanData.fromJson(Map<String, dynamic> json) =>
      _$TextSpanDataFromJson(json);
}

@freezed
class NodeModel with _$NodeModel {
  const factory NodeModel({
    required String id,
    required String mindmapId,
    @Default('Neuer Knoten') String text,
    @Default('') String notes,
    required double x,
    required double y,
    @Default(160.0) double width,
    @Default(80.0) double height,
    /// Color stored as int value (e.g. 0xFF4A6CF7)
    @Default(0xFF4A6CF7) int color,
    @Default(NodeShape.roundedRectangle) NodeShape shape,
    @Default(false) bool isBold,
    @Default(15.0) double fontSize,
    /// Rich text formatting as list of spans
    @Default([]) List<TextSpanData> textSpans,
    @Default('') String imageUrl,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _NodeModel;

  factory NodeModel.fromJson(Map<String, dynamic> json) =>
      _$NodeModelFromJson(json);
}

