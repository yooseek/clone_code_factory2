import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/utils/pagination_utils.dart';
import 'package:code_factory2/product/component/product_card.dart';
import 'package:code_factory2/rating/component/rating_card.dart';
import 'package:code_factory2/rating/model/rating_model.dart';
import 'package:code_factory2/rating/riverpod/rating_provider.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

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

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치면
    // 새로운 데이터를 추가 요청
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(ratingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(ratingProvider(widget.id));

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
            controller: controller,
        slivers: [
          // 일반 위젯을 sliver 형태로 넣을 때
          SliverToBoxAdapter(
            child: RestaurantCard.fromModel(model: state, isDetail: true),
          ),

          // 디테일 정보가 로딩 중일 때
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel)
            // 일반 위젯을 sliver 형태로 넣을 때 - Label
            const SliverPadding(
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
                          ProductCard.fromRestaurantProductModel(model: state.products[index]),
                    );
                  },
                  childCount: state.products.length,
                ),
              ),
            ),
          if (ratingState is CursorPagination<RatingModel>)
            renderRatings(models: ratingState.data),
        ],
      ),
    );
  }

  // 로딩 중에 로딩표시 보여주기 - skeletons
  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  // 몇 줄 짜리로 보여줄껀지
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding renderRatings({required List<RatingModel> models}) {
    return SliverPadding(
      padding: EdgeInsets.all(
        16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
                padding: EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: RatingCard.fromModel(model: models[index]));
          },
          childCount: models.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    super.dispose();
  }
}
