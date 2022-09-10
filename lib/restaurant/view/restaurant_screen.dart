import 'package:code_factory2/common/component/Pagination_list_view.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(
        provider: restaurantProvider,
        itemBuilder: <RestaurantModel>(_, index, model) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    RestaurantDetailScreen(id: model.id, name: model.name),
              ));
            },
            child: RestaurantCard.fromModel(model: model),
          );
        });
  }
}
