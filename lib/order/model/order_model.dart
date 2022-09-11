import 'package:code_factory2/common/model/model_with_id.dart';
import 'package:code_factory2/common/utils/data_utils.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel implements IModelWithId{
  final String id;
  final List<OrderProductAndCountModel> products;
  final int totalPrice;
  final RestaurantModel restaurant;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime
  )
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.restaurant,
    required this.createdAt,
  });
  
  factory OrderModel.fromJson(Map<String,dynamic> json) =>
  _$OrderModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

@JsonSerializable()
class OrderProductAndCountModel {
  final OrderProductModel product;
  final int count;

  const OrderProductAndCountModel({
    required this.product,
    required this.count,
  });
  
  factory OrderProductAndCountModel.fromJson(Map<String,dynamic> json) =>
  _$OrderProductAndCountModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$OrderProductAndCountModelToJson(this);
}

@JsonSerializable()
class OrderProductModel {
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson : DataUtils.pathToUrl
  )
  final String imgUrl;
  final int price;

  const OrderProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory OrderProductModel.fromJson(Map<String,dynamic> json) =>
  _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);
}