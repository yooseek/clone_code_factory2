import 'package:code_factory2/common/view/root_tab.dart';
import 'package:code_factory2/common/view/splash_screen.dart';
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
                builder: (context, state) => RestaurantDetailScreen(
                    id: state.params['rid']!),
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
      ];

  // SplashScreen
  String? redirectLogic(GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    final logging = state.location == '/login';

    // 유저 정보가 없는데 로그인 중이면
    // 그대로 로그인 페이지에 두고
    // 만약 로그인 중이 아니라면 로그인 페이지로 이동
    if (user == null) {
      return logging ? null : '/login';
    }

    // 유저 정보가 있을 때
    if (user is UserModel) {
      // 로그인 중이거나 현재 위치가 splash 페이지이면 홈으로 이동
      if (logging || state.location == '/splash') {
        return '/';
      } else {
        // 아니면 현재 페이지 그대로 유지
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
