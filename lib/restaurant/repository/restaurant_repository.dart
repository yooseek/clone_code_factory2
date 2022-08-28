import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  // http://127.0.0.1:3000/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://127.0.0.1:3000/restaurant/
  // @GET('/')
  // paginate();

  // http://127.0.0.1:3000/restaurant/{id}
  @GET('/{id}')
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path('id') required String id,
  });
}
