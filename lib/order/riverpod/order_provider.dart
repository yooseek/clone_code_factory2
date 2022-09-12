import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/model/pagination_params.dart';
import 'package:code_factory2/common/riverpod/pagination_provider.dart';
import 'package:code_factory2/order/model/order_model.dart';
import 'package:code_factory2/order/model/post_order_body.dart';
import 'package:code_factory2/order/repository/order_repository.dart';
import 'package:code_factory2/user/riverpod/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier extends PaginationProvider<OrderModel,OrderRepository> {
  final Ref ref;
  OrderStateNotifier({
    required this.ref,
    required super.repository,
  });

  Future<bool> postOrder() async {
    final basketState = ref.read(basketProvider);

    final uuid = Uuid();
    final id = uuid.v4();

    try {
      final response = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: basketState
              .map<PostOrderBodyProduct>(
                (e) => PostOrderBodyProduct(
                    productId: e.product.id, count: e.count),
              )
              .toList(),
          totalPrice: basketState.fold(0, (p, e) => p + (e.product.price * e.count)),
          createdAt: DateTime.now().toString(),
        ),
      );

      await paginate(forceRefetch: true);
      ref.read(basketProvider.notifier).removeAllBasket();

      return true;
    } catch (e) {
      return false;
    }
  }
}
