import 'package:dio/dio.dart';
import 'package:fusion_healthcare/core/api_constant.dart';
import 'package:fusion_healthcare/core/api_key_interceptor.dart';

class SecureDio {
  static Future<Dio> create() async {
    //final httpClient = await SecureHttpClient.create();
    final dio = Dio();

    // dio.httpClientAdapter = IOHttpClientAdapter(
    //   createHttpClient: () => httpClient,
    // );

    dio.interceptors.add(
      ApiKeyInterceptor(
        apiKeyName: ApiConstant.apiKeyName,
        apiKeyValue: ApiConstant.apiKeyValue,
      ),
    );

    return dio;
  }
}
