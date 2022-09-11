import 'dart:convert';

import 'package:code_factory2/common/const/data.dart';

class DataUtils {
  static String pathToUrl(String thumbUrl) {
    return 'http://$ip$thumbUrl';
  }

  static List<String> listPathToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainTobase64(String plainString) {
    // 일반스트링을 base64로 인코딩
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plainString);

    return encoded;
  }

  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }
}