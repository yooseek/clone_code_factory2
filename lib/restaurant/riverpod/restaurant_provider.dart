import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../common/riverpod/pagination_provider.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  // import 'package:collection/collection.dart';
  // 찾는 값이 없을 때 오류가 아닌 null을 반환
  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier extends PaginationProvider<RestaurantModel,RestaurantRepository> {
  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 데이터가 하나도 없는 상태라면 - (CursorPaginantion) 이 아니라면
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // 다시 paginate를 했는데도 state가 CursorPaginantion 이 아니라면
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final RestaurantDetailModel response =
        await repository.getRestaurantDetail(id: id);

    // restaurantModel은 없는데 restaurantDetailModel을 가져왔을 때
    // 그냥 뒤에 추가
    if(pState.data.where((element) => element.id == id).isEmpty) {
      state = pState.copyWith(
        data: <RestaurantModel>[
          ...pState.data,
          response,
        ]
      );
    }else {
      // 현재 pState는 restaurantModel,
      // 디테일을 한 번 불러오면 해당 restaurantModel을 restaurantDetailModel로 전환
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>(
              (e) => e.id == id ? response : e,
        )
            .toList(),
      );
    }
  }
}
