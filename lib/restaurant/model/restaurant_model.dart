import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/model/model_with_id.dart';
import 'package:code_factory2/common/utils/data_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable()
class RestaurantModel implements IModelWithId{
  // id
  final String id;

  // 레스토랑 이름
  final String name;

  // 썸네일 url
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String thumbUrl;

  // 레스토랑 태그
  final List<String> tags;

  // 가격 범위
  final RestaurantPriceRange priceRange;

  // 평균 평점
  final double ratings;

  // 평점 갯수
  final int ratingsCount;

  // 배송걸리는 시간
  final int deliveryTime;

  // 배송 비용
  final int deliveryFee;
  
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}