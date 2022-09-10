import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromRestaurantProductModel({required RestaurantProductModel model}) {
    return ProductCard(
        image: Image.network(
          model.imgUrl,
          fit: BoxFit.cover,
          width: 110,
          height: 110,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price);
  }

  factory ProductCard.fromProductModel({required ProductModel model}) {
    return ProductCard(
        image: Image.network(
          model.imgUrl,
          fit: BoxFit.cover,
          width: 110,
          height: 110,
        ),
        name: model.name,
        detail: model.detail,
        price: model.price);
  }

  @override
  Widget build(BuildContext context) {
    // 내부의 위젯들이 최대의 높이를 가진채로 됨 - IntrinsicHeight
    // 원래는 각자의 위젯들은 각자의 높이를 가지고 있다.
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  // 텍스트가 맥스라인을 넘어갔을 때 어떻게 표현 할 것인가
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: BODY_TEXT_COLOR,
                  ),
                ),
                Text(
                  '₩ $price',
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
