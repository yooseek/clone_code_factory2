import 'package:badges/badges.dart';
import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/utils/pagination_utils.dart';
import 'package:code_factory2/product/component/product_card.dart';
import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/rating/component/rating_card.dart';
import 'package:code_factory2/rating/model/rating_model.dart';
import 'package:code_factory2/rating/riverpod/rating_provider.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:code_factory2/restaurant/view/basket_screen.dart';
import 'package:code_factory2/user/riverpod/basket_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

import '../model/restaurant_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  static String get routerName => 'restaurantDetail';

  final String id;

  const RestaurantDetailScreen({required this.id, Key? key}) : super(key: key);

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
    // ?????? ????????? ?????? ???????????? ?????? ??? ?????? ?????????
    // ????????? ???????????? ?????? ??????
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(ratingProvider(widget.id).notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingState = ref.watch(ratingProvider(widget.id));
    final basketState = ref.watch(basketProvider);

    if (state == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultLayout(
      title: state.name,
      // floatingActionButton ??? ?????? ????????????
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(BasketScreen.routeName);
        },
        backgroundColor: PRIMARY_COLOR,
        child: Badge(
          // ?????? ????????? ???????????????
          showBadge: basketState.isNotEmpty,
          // ?????? ????????? ??????
          badgeContent: Text(
            basketState
                .fold<int>(0,
                    (previousValue, element) => previousValue + element.count)
                .toString(),
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 10.0,
            ),
          ),
          // ?????? ??????
          position: BadgePosition(top: - 16,end: -16),
          child: Icon(Icons.shopping_basket_outlined),
          badgeColor: Colors.white,
        ),
      ),
      child:
          // ??? ?????? ???????????? ???????????? ?????? ????????? ??????????????? ???????????? ?????? ???
          CustomScrollView(
        controller: controller,
        slivers: [
          // ?????? ????????? sliver ????????? ?????? ???
          SliverToBoxAdapter(
            child: RestaurantCard.fromModel(model: state, isDetail: true),
          ),

          // ????????? ????????? ?????? ?????? ???
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel)
            // ?????? ????????? sliver ????????? ?????? ??? - Label
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  '??????',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),

          if (state is RestaurantDetailModel)
            // List ??? ????????? sliver ????????? ?????? ???
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final model = state.products[index];

                    return InkWell(
                      onTap: () {
                        ref.read(basketProvider.notifier).addToBasket(
                              product: ProductModel(
                                  id: model.id,
                                  name: model.name,
                                  detail: model.detail,
                                  imgUrl: model.imgUrl,
                                  price: model.price,
                                  restaurant: state),
                            );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ProductCard.fromRestaurantProductModel(
                            model: model),
                      ),
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

  // ?????? ?????? ???????????? ???????????? - skeletons
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
                  // ??? ??? ????????? ???????????????
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
