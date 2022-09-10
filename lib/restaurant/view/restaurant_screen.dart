import 'package:code_factory2/common/component/pagination_list_view.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              // 아래와 같은 역할
              // context.go('/restaurant/${model.id}');

              context.goNamed(
                RestaurantDetailScreen.routerName,
                params: {'rid': model.id},
              );
            },
            child: RestaurantCard.fromModel(model: model),
          );
        });
  }
}
