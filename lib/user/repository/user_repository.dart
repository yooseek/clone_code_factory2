import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/user/model/basket_item_model.dart';
import 'package:code_factory2/user/model/patch_basket_body.dart';
import 'package:code_factory2/user/model/user_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'user_repository.g.dart';

final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  final dio = ref.watch(dioProvider);

  return UserMeRepository(dio, baseUrl: 'http://$ip/user/me');
});

@RestApi()
abstract class UserMeRepository {
  factory UserMeRepository(Dio dio, {String baseUrl}) = _UserMeRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @GET('/basket')
  @Headers({'accessToken': 'true'})
  Future<BasketItemModel> getBasket();

  @PATCH('/basket')
  @Headers({'accessToken': 'true'})
  Future<BasketItemModel> patchBasket({
    @Body() required PatchBasketBody body,
  });
}
