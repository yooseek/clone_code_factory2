import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                // 데이터가 없을 떄 - 원래는 에러페이지를 리턴하던지 해야함
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    // 각 아이템 별로 하나의 RestaurantCard를 구성하게 됨
                    final item = snapshot.data![index];

                    // 일일이 하는 법 - factory constructor를 사용하자
                    final pItem2 = RestaurantModel(
                      id: item['id'],
                      name: item['name'],
                      thumbUrl: 'http://$ip${item['thumbUrl']}',
                      tags: List<String>.from(item['tags']),
                      priceRange: RestaurantPriceRange.values.firstWhere(
                        (element) => element.name == item['priceRange'],
                      ),
                      ratings: item['ratings'],
                      ratingsCount: item['ratingsCount'],
                      deliveryTime: item['deliveryTime'],
                      deliveryFee: item['deliveryFee'],
                    );

                    // 팩토리 constructor 사용하는 법
                    final pItem = RestaurantModel.fromJson(item);

                    // 팩토리 constructor 사용하는 법
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RestaurantDetailScreen(id: pItem.id,name: pItem.name),
                        ));
                      },
                      child: RestaurantCard.fromModel(model: pItem),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: BODY_TEXT_COLOR,
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              },
            )),
      ),
    );
  }

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final response = await dio.get(
      'http://$ip/restaurant',
      options: Options(headers: {
        'authorization': 'Bearer $accessToken',
      }),
    );

    return response.data['data'];
  }
}
