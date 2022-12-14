import 'package:code_factory2/common/view/root_tab.dart';
import 'package:code_factory2/common/view/splash_screen.dart';
import 'package:code_factory2/order/view/order_done_screen.dart';
import 'package:code_factory2/restaurant/view/basket_screen.dart';
import 'package:code_factory2/restaurant/view/restaurant_detail_screen.dart';
import 'package:code_factory2/user/model/user_model.dart';
import 'package:code_factory2/user/riverpod/user_me_provider.dart';
import 'package:code_factory2/user/view/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
            path: '/',
            name: RootTab.routeName,
            builder: (context, state) => RootTab(),
            routes: [
              GoRoute(
                path: 'restaurant/:rid',
                name: RestaurantDetailScreen.routerName,
                builder: (context, state) =>
                    RestaurantDetailScreen(id: state.params['rid']!),
              ),
            ]),
        GoRoute(
            path: '/splash',
            name: SplashScreen.routeName,
            builder: (context, state) => SplashScreen()),
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            builder: (context, state) => LoginScreen()),
        GoRoute(
            path: '/basket',
            name: BasketScreen.routeName,
            builder: (context, state) => BasketScreen()),
        GoRoute(
            path: '/order_done',
            name: OrderDoneScreen.routeName,
            builder: (context, state) => OrderDoneScreen()),
      ];

  // SplashScreen
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logging = state.location == '/login';

    // ?????? ????????? ????????? ????????? ?????????
    // ????????? ????????? ???????????? ??????
    // ?????? ????????? ?????? ???????????? ????????? ???????????? ??????
    if (user == null) {
      return logging ? null : '/login';
    }

    // ?????? ????????? ?????? ???
    if (user is UserModel) {
      // ????????? ???????????? ?????? ????????? splash ??????????????? ????????? ??????
      if (logging || state.location == '/splash') {
        return '/';
      } else {
        // ????????? ?????? ????????? ????????? ??????
        return null;
      }
    }

    if (user is UserModelError) {
      return !logging ? '/login' : null;
    }

    return null;
  }

  void logout() {
    ref.read(userMeProvider.notifier).logout();
  }
}
