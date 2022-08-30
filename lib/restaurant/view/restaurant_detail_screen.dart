import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:code_factory2/product/component/product_card.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_detail_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  final String name;

  const RestaurantDetailScreen({required this.id,required this.name, Key? key}) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    // 인터셉터 추가
    dio.interceptors.add(CustomInterceptor(storage: storage));

    final repository = RestaurantRepository(dio,baseUrl: 'http://$ip/restaurant');
    
    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: name,
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (context,AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // 두 개의 리스트가 존재하고 대신 하나의 리스트처럼 움직이고 싶을 때
          return renderCustomScrollView(item: snapshot.data!);
        },
      ),

    );
  }

  CustomScrollView renderCustomScrollView({required RestaurantDetailModel item}) {

    // 두 개의 리스트가 존재하고 대신 하나의 리스트처럼 움직이고 싶을 때
    return CustomScrollView(
      slivers: [
        // 일반 위젯을 sliver 형태로 넣을 때
        SliverToBoxAdapter(
          child: RestaurantCard.fromModel(model: item,isDetail: true),
        ),

        // 일반 위젯을 sliver 형태로 넣을 때 - Label
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverToBoxAdapter(
            child: Text(
              '메뉴',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
          ),
        ),

        // List 할 위젯을 sliver 형태로 넣을 때
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ProductCard.fromModel(model: item.products[index]),
                );
              },
              childCount: item.products.length,
            ),
          ),
        )
      ],
    );
  }
}