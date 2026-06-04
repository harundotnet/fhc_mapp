import 'package:dio/dio.dart';

class ApiKeyInterceptor extends Interceptor {
  final String apiKeyName;
  final String apiKeyValue;

  ApiKeyInterceptor({required this.apiKeyName, required this.apiKeyValue});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[apiKeyName] = apiKeyValue;
    return handler.next(options);
  }
}
