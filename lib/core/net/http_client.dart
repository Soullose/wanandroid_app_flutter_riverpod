import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// import 'interceptors/token_interceptors.dart';
import 'interceptors/cookie_interceptors.dart';
import 'interceptors/error_interceptors.dart';
import 'interceptors/header_interceptor.dart';
import 'interceptors/response_interceptors.dart';
import 'result_data.dart';

part 'http_client.g.dart';

// @Riverpod(keepAlive: true)
@riverpod
class HttpManager extends _$HttpManager {
  static const Duration _defaultConnectTimeout = Duration(seconds: 10);
  static const Duration _defaultReceiveTimeout = Duration(seconds: 10);
  static const Duration _defaultSendTimeout = Duration(seconds: 10);
  late final Dio dio;
  bool _initialized = false;

  // HttpManager() {
  // 在构造函数中同步添加拦截器
  // _initInterceptors();
  // }

  // void _initInterceptors() {
  //   dio.interceptors.add(HeaderInterceptors());
  //   // dio.interceptors.add(TokenInterceptors(ref: ref));
  //   dio.interceptors.add(ErrorInterceptors());
  //   dio.interceptors.add(ResponseInterceptors());
  // }

  @override
  Future<void> build() async {
    if (_initialized) return; // 防止重复初始化
    _initialized = true;

    dio = Dio()
      ..httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final HttpClient client = HttpClient();
          client.badCertificateCallback = (cert, host, port) {
            return true;
          };
          return client;
        },
      );

    // ✅ 所有拦截器统一在这里加，只加一次
    dio.interceptors.addAll([
      HeaderInterceptor(),
      // CookieInterceptors(ref: ref), // ref 在 build 里可用
      ErrorInterceptors(),
      ResponseInterceptors(),
    ]);
    // CookieInterceptors 需要 ref，所以在 build 中添加
    // dio.interceptors.add(CookieInterceptors(ref: ref));
    // dio.interceptors.add(PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90,
    //     enabled: kDebugMode,
    //     filter: (options, args) {
    //       // don't print requests with uris containing '/posts'
    //       // if(options.path.contains('/posts')){
    //       //   return false;
    //       // }
    //       // don't print responses with unit8 list data
    //       return !args.isResponse || !args.hasUint8ListData;
    //     }));
  }

  static const contentTypeJson = "application/json";
  static const contentTypeForm = "application/x-www-form-urlencoded";

  Future<ResultData?> netFetch(
    String url, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    Map<String, dynamic>? header,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    noTip = false,
    ResponseType? responseType = ResponseType.json,
  }) async {
    const methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head',
    };

    options ??= Options(method: methodValues[method]);
    if (header != null) {
      options.headers ??= {};
      options.headers!.addAll(header);
    }

    try {
      final response = await dio.request(
        url,
        queryParameters: params,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (kDebugMode) {
        debugPrint('response: ${response.data}');
      }

      if (response.data is ResultData) {
        return response.data as ResultData;
      }

      return ResultData(
        data: response.data,
        success: true,
        code: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleError(e, url);
    }
  }
}

/// 处理错误
ResultData _handleError(DioException e, String url) {
  int code = e.response?.statusCode ?? -1;

  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    code = -2;
  }

  return ResultData(
    data: null,
    success: false,
    code: code,
    message: e.message ?? '请求失败',
  );
}

enum DioMethod { get, post, put, delete, patch, head }
