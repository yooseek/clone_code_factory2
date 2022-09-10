// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../restaurant/model/restaurant_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantProductModel _$ProductModelFromJson(Map<String, dynamic> json) => RestaurantProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: DataUtils.pathToUrl(json['imgUrl'] as String),
      detail: json['detail'] as String,
      price: json['price'] as int,
    );

Map<String, dynamic> _$ProductModelToJson(RestaurantProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'detail': instance.detail,
      'price': instance.price,
    };
