import 'package:code_factory2/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelLoading extends UserModelBase {}

class UserModelError extends UserModelBase {
  final String error;

  UserModelError({required this.error});
}

@JsonSerializable()
class UserModel extends UserModelBase{
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathToUrl
  )
  final String imageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });

  factory UserModel.fromJson(Map<String,dynamic> json) =>
  _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}