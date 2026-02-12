import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thinknode/core/utils/timestamp_converter.dart';

part 'cursor_presence_model.freezed.dart';
part 'cursor_presence_model.g.dart';

@freezed
class CursorPresenceModel with _$CursorPresenceModel {
  const factory CursorPresenceModel({
    required String userId,
    required String displayName,
    /// Color stored as int value
    required int color,
    required double x,
    required double y,
    @TimestampConverter() required DateTime lastSeen,
  }) = _CursorPresenceModel;

  factory CursorPresenceModel.fromJson(Map<String, dynamic> json) =>
      _$CursorPresenceModelFromJson(json);
}

