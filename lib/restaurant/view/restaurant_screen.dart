import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/utils/pagination_utils.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치면
    // 새로운 데이터를 추가 요청
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantProvider.notifier),
    );
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 첫 로딩 중일 떄
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러일 때
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching
    final cp = data as CursorPagination;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (context, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: data is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('마지막 데이터입니다.'),
              ),
            );
          }

          // 각 아이템 별로 하나의 RestaurantCard를 구성하게 됨

          // 팩토리 constructor 사용하는 법 x
          // retrofit 사용법
          final pItem = cp.data[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    RestaurantDetailScreen(id: pItem.id, name: pItem.name),
              ));
            },
            child: RestaurantCard.fromModel(model: pItem),
          );
        },
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: BODY_TEXT_COLOR,
              thickness: 2.0,
            ),
          );
        },
      ),
    );
  }
}
