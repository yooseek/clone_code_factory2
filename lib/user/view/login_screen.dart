import 'dart:convert';

import 'package:code_factory2/common/component/text_form_feild.dart';
import 'package:code_factory2/common/const/colors.dart';
import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/layout/default_layout.dart';
import 'package:code_factory2/common/secure_storage/secure_storage.dart';
import 'package:code_factory2/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';

  final dio = Dio();

  @override
  Widget build(BuildContext context) {

    return DefaultLayout(
      child: SafeArea(
        top: true,
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag, // 드래그를 했을 때 키보드가 사라진다.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                const SizedBox(
                  height: 16.0,
                ),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  width: MediaQuery.of(context).size.width / 3,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 아이디 비번
                    final rowString = '$username:$password';

                    // 아이디 비번 인코딩
                    Codec<String, String> stringToBase64 =
                        utf8.fuse(base64); // 일반스트링을 base64로 인코딩

                    // 토큰으로 생성
                    String token = stringToBase64.encode(rowString);

                    // 헤더에 토큰 달고 api 요청
                    final response = await dio.post(
                      'http://$ip/auth/login',
                      options: Options(headers: {
                        'authorization': 'Basic $token',
                      }),
                    );

                    // refreshToken과 accessToken 받음
                    final refreshToken = response.data['refreshToken'];
                    final accessToken = response.data['accessToken'];

                    final storage = ref.read(secureStorageProvider);
                    
                    // 토큰 저장
                    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => RootTab()),
                    );
                  },
                  child: Text('로그인'),
                  style: ElevatedButton.styleFrom(
                    primary: PRIMARY_COLOR,
                  ),
                ),
                TextButton(
                  onPressed: () async {

                  },
                  child: Text('회원가입'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다.',
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(fontSize: 16, color: BODY_TEXT_COLOR),
    );
  }
}
