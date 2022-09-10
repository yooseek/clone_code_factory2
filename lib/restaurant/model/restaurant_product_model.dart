import 'package:code_factory2/common/model/model_with_id.dart';
import 'package:code_factory2/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_product_model.g.dart';

@JsonSerializable()
class RestaurantProductModel implements IModelWithId{
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl
  )
  final String imgUrl;
  final String detail;
  final int price;

  const RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String,dynamic> json) =>
  _$RestaurantProductModelFromJson(json);

}