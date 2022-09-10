import 'package:code_factory2/product/model/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basket_item_model.g.dart';

@JsonSerializable()
class BasketItemModel {
  final ProductModel product;
  final int count;

  const BasketItemModel({
    required this.product,
    required this.count,
  });


  
  factory BasketItemModel.fromJson(Map<String,dynamic> json) =>
  _$BasketItemModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$BasketItemModelToJson(this);

  BasketItemModel copyWith({
    ProductModel? product,
    int? count,
  }) {
    return BasketItemModel(
      product: product ?? this.product,
      count: count ?? this.count,
    );
  }
}