import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/model/pagination_params.dart';
import 'package:code_factory2/common/respository/base_pagination_repository.dart';
import 'package:code_factory2/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'rating_repository.g.dart';

final ratingRepositoryProvider =
    Provider.family<RatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);

  final repository = RatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');

  return repository;
});

// http://ip/restaurant/:rid/rating
@RestApi()
abstract class RatingRepository implements IBasePaginationRepository<RatingModel> {
  factory RatingRepository(Dio dio, {String baseUrl}) = _RatingRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<CursorPagination<RatingModel>> paginate({
    // retrofit 에서의 쿼리 추가
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
