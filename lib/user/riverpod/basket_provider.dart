import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/user/model/basket_item_model.dart';
import 'package:code_factory2/user/model/patch_basket_body.dart';
import 'package:code_factory2/user/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);

  return BasketProvider(repository: repository);
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 요청을 먼저 보내고, 응답이 오면, 캐시를 업데이트
    // Optimistic Response (긍정적 응답) - 응답의 성공을 가정하고 상태를 먼저 업데이트함

    // import collection
    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;

    if (exists) {
      // 장바구니에 해당 상품이 있을 때
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    } else {
      // 장바구니에 해당 상품이 없을 때
      state = [...state, BasketItemModel(product: product, count: 1)];
    }

    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    // true면 카운트와 상관없이 삭제
    bool isDelete = false,
  }) async {
    final exists =
        state.firstWhereOrNull((element) => element.product.id == product.id) !=
            null;
    // 장바구나에 해당 상품이 없을 때 - 뭔가 오류
    if (!exists) {
      return;
    }

    // 장바구니에 해당 상품이 있을 때
    final existingProduct =
        state.firstWhere((element) => element.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      // 해당 상품의 카운트가 1일 때는 상품 삭제
      state =
          state.where((element) => element.product.id != product.id).toList();
    } else {
      // 해당 상품의 카운트가 1이상 일 때는 카운트 다운
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e,
          )
          .toList();
    }

    await patchBasket();
  }

  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map(
              (e) => PatchBasketBodyBasket(
                  productId: e.product.id, count: e.count),
            )
            .toList(),
      ),
    );
  }
}
