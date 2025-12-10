
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

final apiClientProvider = Provider<Dio>((ref)
    {
        return ApiClient().dio;
    }
);

class ApiClient
{
    static final ApiClient _instance = ApiClient._internal();
    factory ApiClient() => _instance;

    late Dio dio;
    final CookieJar _cookieJar = CookieJar();

    String? _token;

    ApiClient._internal()
    {
        BaseOptions options = BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            validateStatus: (status)
            {
                return status != null;
            },
        );

        dio = Dio(options);

        dio.interceptors.add(InterceptorsWrapper(
                onRequest: (options, handler)
                {
                    if (_token != null)
                    {
                        options.headers['Authorization'] = 'Token $_token';
                        print('--- Django Token Added to Header ---');
                    }
                    return handler.next(options);
                },
            ));

        dio.interceptors.add(CookieManager(_cookieJar));

        dio.interceptors.add(LogInterceptor(
                responseBody: true,
                requestBody: true,
            ));
    }

    void setAuthToken(String token)
    {
        _token = token;
        print('--- Auth Token Set in ApiClient ---');
    }

    void clearAuthToken()
    {
        _token = null;
        print('--- Auth Token Cleared from ApiClient ---');
    }
}
