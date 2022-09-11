import 'package:code_factory2/order/model/order_model.dart';
import 'package:code_factory2/order/model/post_order_body.dart';
import 'package:code_factory2/order/repository/order_repository.dart';
import 'package:code_factory2/user/riverpod/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, List<OrderModel>>((ref) {
  final repository = ref.watch(orderRepositoryProvider);

  return OrderStateNotifier(ref: ref, repository: repository);
});

class OrderStateNotifier extends StateNotifier<List<OrderModel>> {
  final Ref ref;
  final OrderRepository repository;
  OrderStateNotifier({
    required this.ref,
    required this.repository,
  }) : super([]);

  Future<bool> postOrder() async {
    final state = ref.read(basketProvider);

    final uuid = Uuid();
    final id = uuid.v4();

    try {
      final response = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map<PostOrderBodyProduct>(
                (e) => PostOrderBodyProduct(
                    productId: e.product.id, count: e.count),
              )
              .toList(),
          totalPrice: state.fold(0, (p, e) => p + (e.product.price * e.count)),
          createdAt: DateTime.now().toString(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
