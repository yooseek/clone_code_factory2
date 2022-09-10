import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/riverpod/pagination_provider.dart';
import 'package:code_factory2/product/model/product_model.dart';
import 'package:code_factory2/product/respository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(productRespositoryProvider);

  return ProductNotifier(repository: repository);
});

class ProductNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductNotifier({required super.repository});
}
