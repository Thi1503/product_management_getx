import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:product_management_getx/data/models/user.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(baseUrl: 'https://training-api-unrp.onrender.com'),
      ) {
    // 1) Thêm LogInterceptor để log toàn bộ request/response
    dio.interceptors.add(
      LogInterceptor(requestHeader: true, requestBody: true),
    );

    // 2) Thêm Interceptor để tự động thêm token vào header
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final hiveAuth = Hive.box<User>('authBox');
          final user = hiveAuth.isNotEmpty ? hiveAuth.get('accessToken') : null;
          if (user != null && user.accessToken.isNotEmpty) {
            options.headers['Authorization'] = user.accessToken;
          }
          handler.next(options);
        },
      ),
    );
  }
}
