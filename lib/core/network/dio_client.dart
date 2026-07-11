import 'package:dio/dio.dart';
import '../config/app_config.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio.options.baseUrl = AppConfig.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer ${AppConfig.apiKey}';
          options.headers['X-Tenant-Id'] = AppConfig.tenantId;
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
  }
}
