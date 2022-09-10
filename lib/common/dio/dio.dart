// Dio Interceptor

import 'package:code_factory2/common/const/data.dart';
import 'package:code_factory2/common/secure_storage/secure_storage.dart';
import 'package:code_factory2/user/riverpod/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Provider로 만들기
final dioProvider = Provider<Dio>((ref){
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage,ref: ref));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({required this.storage,required this.ref,});

  // 1) 요청을 보낼 때
  // 요청이 보내질 때마다 해당 인터셉터에서
  // 요청 Header에 accessToken : true 라는 값이 있다면
  // 실제 토큰을 가져와서 적용한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQUEST] [${options.method} ${options.uri}]');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RESPONSE] [${response.requestOptions.method} ${response.requestOptions.uri}]');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERROR] [${err.requestOptions.method} ${err.requestOptions.uri}]');
    if(err.response!.statusCode == 401) {
      print('[ERROR] [${err.message}] accessToken 만료');
    }

    // 401에러가 났을 때 ( status code )
    // 액세스 토큰이 재발급이 필요할 때 - 기간 만료 등..
    // 다시 새로운 토큰으로 요청을 한다.

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // 현재 리프레쉬 토큰도 없으면 에러를 발생 시킨다.
    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401; // 에러 코드가 401 인가?
    final isPathRefresh =
        err.requestOptions.path == '/auth/token'; // token을 재발급 받으려 하는가

    // 에러코드가 401이고, token을 재발급 받으려는 요청의 에러가 아닌경우
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try{
        // 새로운 access 토큰 발급 요청
        final response = await dio.post(
          'http://$ip/auth/token',
          options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
        );

        final accessToken = response.data['accessToken'];

        // 받은 accessToken을 에러를 발생시킨 request의 헤더에 삽입
        final options = err.requestOptions;
        options.headers.addAll(
          {'authorization' : 'Bearer $accessToken'}
        );

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 에러를 발생시킨 request를 다시 보냄 - 헤더만 바꿔서 보낸 요청의 값으로 에러 resolve
        final res = await dio.fetch(options);

        return handler.resolve(res);

      }on DioError catch(e){
        // refresh 토큰까지 만료 되었을 때 로그아웃하기

        // circular dependency error 발생 (provider 사용시 주의)
        // provider(dio 참조) - dio(provider 참조) - provider(dio 참조) ...

        // dio를 참조하지 않는 프로바이더를 사용해서 logdout 구현하기
        ref.read(authProvider.notifier).logout();

        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
