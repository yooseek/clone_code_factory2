// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:code_factory2/common/model/cursor_pagination_model.dart';
import 'package:code_factory2/common/model/pagination_params.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/model/restaurant_product_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory2/restaurant/riverpod/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:code_factory2/main.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository implements RestaurantRepository {
  bool getMockRepositoryCalled = false;

  @override
  Future<RestaurantDetailModel> getRestaurantDetail(
      {required String id}) async {

    getMockRepositoryCalled = true;

    return RestaurantDetailModel(
      detail: 'testDetail',
      products: [
        RestaurantProductModel(
            id: id,
            name: 'test',
            imgUrl: 'test.png',
            detail: 'detail',
            price: 1000),
      ],
      id: id,
      thumbUrl: 'testThum.png',
      tags: ['test'],
      deliveryTime: 1,
      deliveryFee: 1000,
      name: 'test',
      ratingsCount: 5,
      ratings: 1.1,
      priceRange: RestaurantPriceRange.cheap,
    );
  }

  @override
  Future<CursorPagination<RestaurantModel>> paginate({PaginationParams? paginationParams = const PaginationParams()}) {
    // TODO: implement paginate
    throw UnimplementedError();
  }
}

class MockRepo extends Mock implements RestaurantRepository{}

void main() {
  late RestaurantStateNotifier restaurantStateNotifier;
  late MockRepo mockRepo;

  setUp(() => {
    mockRepo = MockRepo(),
    restaurantStateNotifier = RestaurantStateNotifier(repository: mockRepo),
  });

  test('restaurant getRestaurantDetail test', () async {
    expect(await restaurantStateNotifier.testGetDetail(), []);
  });

  group('group test', () {
    test('restaurant getRestaurantDetail group test', () async {
      when(()=> mockRepo.getRestaurantDetail(id: '1')).thenAnswer((invocation) async => RestaurantDetailModel(
        detail: 'testDetail',
        products: [
          RestaurantProductModel(
              id: '1',
              name: 'test',
              imgUrl: 'test.png',
              detail: 'detail',
              price: 1000),
        ],
        id: '1',
        thumbUrl: 'testThum.png',
        tags: ['test'],
        deliveryTime: 1,
        deliveryFee: 1000,
        name: 'test',
        ratingsCount: 5,
        ratings: 1.1,
        priceRange: RestaurantPriceRange.cheap,
      ),);
      await restaurantStateNotifier.testGetDetail();

      verify(()=> mockRepo.getRestaurantDetail(id: '1')).called(1);
    });
  });

}
