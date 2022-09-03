import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:code_factory2/product/component/product_card.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({required this.id, required this.name, Key? key})
      : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultLayout(
      title: widget.name,
      child:
          // 두 개의 리스트가 존재하고 대신 하나의 리스트처럼 움직이고 싶을 때
          CustomScrollView(
        slivers: [
          // 일반 위젯을 sliver 형태로 넣을 때
          SliverToBoxAdapter(
            child: RestaurantCard.fromModel(model: state, isDetail: true),
          ),

          if (state is RestaurantDetailModel)
            // 일반 위젯을 sliver 형태로 넣을 때 - Label
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '메뉴',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          if (state is RestaurantDetailModel)
            // List 할 위젯을 sliver 형태로 넣을 때
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child:
                          ProductCard.fromModel(model: state.products[index]),
                    );
                  },
                  childCount: state.products.length,
                ),
              ),
            )
        ],
      ),
    );
  }
}
