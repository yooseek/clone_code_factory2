import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/user/model/basket_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  BasketProvider() : super([]);

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
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
  }
}
