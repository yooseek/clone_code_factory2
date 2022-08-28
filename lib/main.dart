import 'package:code_factory2/common/component/text_form_feild.dart';
import 'package:code_factory2/common/view/splash_screen.dart';
import 'package:code_factory2/user/view/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //터치시 키보드 내리기
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NotoSans'
        ),
        home: SplashScreen(),
      ),
    );
  }
}
