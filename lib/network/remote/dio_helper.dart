import 'package:dio/dio.dart';

class DioHelper {
  //v2/top-headlines?country=us&category=business&apiKey=65f7f556ec76449fa7dc7c0069f040ca
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://newsapi.org/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
    required Map<String, dynamic> query,
  }) async {
    return await dio!.get(url, queryParameters: query);
  }
}
