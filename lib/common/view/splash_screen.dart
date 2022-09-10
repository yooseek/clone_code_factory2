import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static String get routeName => 'splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            SizedBox(
              height: 16.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // deleteToken();
  //   checkToken();
  // }
  //
  // void checkToken() async {
  //   final storage = ref.read(secureStorageProvider);
  //
  //   // 토큰이 저장되어 있는지 확인
  //   final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
  //   final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  //
  //   final dio = Dio();
  //
  //   // 토큰이 저장되어 있고 유효하면 페이지 이동
  //   try{
  //     // refresh 토큰을 보내서 제대로 200 OK 가 넘어오면
  //     final response = await dio.post(
  //       'http://$ip/auth/token',
  //       options: Options(headers: {
  //         'authorization': 'Bearer $refreshToken',
  //       }),
  //     );
  //
  //     // accessToken 업데이트
  //     await storage.write(key: ACCESS_TOKEN_KEY, value: response.data['accessToken']);
  //
  //     // 루트페이지로 이동
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (_) => RootTab(),
  //       ),
  //           (route) => false,
  //     );
  //   }catch(error){
  //     // 에러가 반환되면 로그인 페이지로 이동
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (_) => LoginScreen(),
  //       ),
  //           (route) => false,
  //     );
  //   }
  // }
  //
  // void deleteToken() async {
  //   final storage = ref.read(secureStorageProvider);
  //
  //   await storage.deleteAll();
  // }
}
