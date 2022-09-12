import 'package:code_factory2/common/component/pagination_list_view.dart';
import 'package:code_factory2/order/component/order_card.dart';
import 'package:code_factory2/order/model/order_model.dart';
import 'package:code_factory2/order/riverpod/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderScreen extends ConsumerWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<OrderModel>(
      provider: orderProvider,
      itemBuilder: <OrderModel>(_, index, model) {
        return OrderCard.fromModel(model: model);
      },
    );
  }
}
