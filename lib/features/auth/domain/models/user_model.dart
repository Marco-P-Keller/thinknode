import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:thinknode/core/utils/timestamp_converter.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String displayName,
    @Default('') String photoUrl,
    @Default(<String>[]) List<String> mindmapIds,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Factory for creating a new user after registration
  factory UserModel.newUser({
    required String id,
    required String email,
    required String displayName,
  }) =>
      UserModel(
        id: id,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
}

