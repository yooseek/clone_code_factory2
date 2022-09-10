import 'package:code_factory2/common/component/pagination_list_view.dart';
import 'package:code_factory2/product/component/product_card.dart';
import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/product/reverpod/product_provider.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              context.goNamed(
                RestaurantDetailScreen.routerName,
                params: {'rid': model.restaurant.id},
              );
            },
            child: ProductCard.fromProductModel(
              model: model,
            ),
          );
        });
  }
}
