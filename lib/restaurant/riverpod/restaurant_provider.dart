import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/model/pagination_params.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);

  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    // 해당 RestaurantStateNotifier 가 생성될 떄 아래 메소드를 실행해라
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // true = 추가로 데이터 더 가져옴
    // false = 새로고침 (현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 상태
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫 번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 떄

      // 조건
      // 1) meta 안에 hasMore 가 false 일 때 (다음 데이터가 없을 때)
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        // 다음 데이터가 없으면 paginate는 더 이상 진행할 필요없음
        if (!pState.meta.hasMore) {
          return;
        }
      }

      // 2) 로딩 중일 때 + fetchMore가 true일 때
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;
      // 로딩 중이면서 새로운 데이터를 추가로 또 요청하면 더 이상 진행할 필요없음
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // 3) 캐시가 되어진 후 데이터를 더 불러올 때 - fetchMore : true
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 4) 데이터를 처음부터 가져오는 상황
      else {
        // 만약 데이터가 있는 상황이라면 기존 데이터를 보존한채로 요청을 진행 - 새로고침
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state =
              CursorPaginationRefetching(meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      // 데이터 요청
      final response =
          await repository.paginate(paginationParams: paginationParams);

      // 데이터 요청 완료된 후처리
      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = response.copyWith(
          data: [...pState.data, ...response.data],
        );
      } else {
        state = response;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오는데 실패했습니다.');
    }
  }

  getDetail({
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
