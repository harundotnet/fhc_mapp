import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'secure_http_client.dart';

class SecureDio {
  static Future<Dio> create() async {
    final httpClient = await SecureHttpClient.create();
    final dio = Dio();

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => httpClient,
    );

    // dio.interceptors.add(
    //   ApiKeyInterceptor(
    //     // apiKeyName: 'XApiKey',
    //     // apiKeyValue:
    //     //     'FW29iamVjdCBIVE1MSW5wdXRFbGVtZW50XVtvYmplY3QgSFRNTElucHV0RWxlbWVudF0=',
    //     apiKeyName: ApiConstant.apiKeyName,
    //     apiKeyValue: ApiConstant.apiKeyValue,
    //   ),
    // );

    return dio;
  }
}
