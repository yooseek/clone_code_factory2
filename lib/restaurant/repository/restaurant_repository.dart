import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/model/pagination_params.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref){
  final dio = ref.watch(dioProvider);

  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
});

@RestApi()
abstract class RestaurantRepository {
  // http://127.0.0.1:3000/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://127.0.0.1:3000/restaurant/
  @GET('/')
  @Headers({
    'accessToken' : 'true'
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    // retrofit 에서의 쿼리 추가
  @Queries() PaginationParams? paginationParams = const PaginationParams(),
});

  // http://127.0.0.1:3000/restaurant/{id}
  @GET('/{id}')
  @Headers({
    'accessToken' : 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String id,
  });
}
