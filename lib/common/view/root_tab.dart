import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:code_factory2/product/view/product_screen.dart';
import 'package:code_factory2/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  late TabController controller;

  int index = 0;

  @override
  void initState() {
    super.initState();

    // vsync엔 컨트롤러를 선언하는 스테이트를 넣어주면 된다. - 보통 애니메이션와 연관된 컨트롤러에서 사용
    // SingleTickerProviderStateMixin 사용하기
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '경식 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,  // 선택되었을 때
        unselectedItemColor: BODY_TEXT_COLOR, // 선택 안되었을 때
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.shifting,  // 선택되었을 때의 아이콘 확장 여부
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
      child: SafeArea(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 스크롤을 해도 넘어가지 않음
          controller: controller,
          children: [
            RestaurantScreen(),
            ProductScreen(),
            Container(child: Text('주문'),),
            Container(child: Text('프로필'),),
          ],
        ),
      ),
    );
  }
}
