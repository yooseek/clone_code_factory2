import 'package:code_factory2/common/component/Pagination_list_view.dart';
import 'package:code_factory2/product/component/product_card.dart';
import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/product/reverpod/product_provider.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) {
                  return RestaurantDetailScreen(
                    id: model.restaurant.id,
                    name: model.restaurant.name,
                  );
                }),
              );
            },
            child: ProductCard.fromProductModel(
              model: model,
            ),
          );
        });
  }
}
