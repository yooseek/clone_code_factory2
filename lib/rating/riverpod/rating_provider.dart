import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/riverpod/pagination_provider.dart';
import 'package:code_factory2/rating/model/rating_model.dart';
import 'package:code_factory2/rating/repository/rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider 자체도 family 로 생성하기
final ratingProvider = StateNotifierProvider.family<RatingProviderStateNotifier,
    CursorPaginationBase, String>((ref, id) {
  final repository = ref.watch(ratingRepositoryProvider(id));

  return RatingProviderStateNotifier(repository: repository);
});

class RatingProviderStateNotifier
    extends PaginationProvider<RatingModel, RatingRepository> {
  RatingProviderStateNotifier({required super.repository});
}
