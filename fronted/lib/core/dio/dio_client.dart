import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../router/app_router.dart';   

class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.100.206:8000/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) debugPrint('➡️ ${options.method} ${options.path}');
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await SecureStorage.clear();
            redirectToLogin(); 
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}