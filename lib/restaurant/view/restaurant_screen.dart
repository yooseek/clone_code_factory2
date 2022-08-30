import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/dio/dio.dart';
import 'package:code_factory2/restaurant/component/restaurant_card.dart';
import 'package:code_factory2/restaurant/model/restaurant_model.dart';
import 'package:code_factory2/restaurant/repository/restaurant_repository.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List<RestaurantModel>>(
              future: paginateRestaurant(ref),
              builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
                // 데이터가 없을 떄 - 원래는 에러페이지를 리턴하던지 해야함
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    // 각 아이템 별로 하나의 RestaurantCard를 구성하게 됨

                    // 팩토리 constructor 사용하는 법 x
                    // retrofit 사용법
                    final pItem = snapshot.data![index];

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

  Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final dio = ref.watch(dioProvider);

    final repository = RestaurantRepository(dio,baseUrl: 'http://$ip/restaurant');
    final response = await repository.paginate();

    return response.data;
  }
}
