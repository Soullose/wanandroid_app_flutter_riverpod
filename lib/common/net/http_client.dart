import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'result_data.dart';

import 'interceptors/error_interceptors.dart';
import 'interceptors/header_interceptor.dart';
import 'interceptors/response_interceptors.dart';

// import 'interceptors/token_interceptors.dart';
import 'interceptors/cookie_interceptors.dart';

part 'http_client.g.dart';

// @Riverpod(keepAlive: true)
@riverpod
class HttpManager extends _$HttpManager {
  @override
  FutureOr build() {
    dio.interceptors.add(HeaderInterceptors());
    dio.interceptors.add(CookieInterceptors(ref: ref));
    // dio.interceptors.add(TokenInterceptors(ref: ref));
    dio.interceptors.add(ErrorInterceptors());
    dio.interceptors.add(ResponseInterceptors());
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          // if(options.path.contains('/posts')){
          //   return false;
          // }
          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        }));
  }

  static const contentTypeJson = "application/json";
  static const contentTypeForm = "application/x-www-form-urlencoded";

  final dio = Dio();

  Future<ResultData?> netFetch(
    url, {
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
      DioMethod.head: 'head'
    };
    options ??= Options(method: methodValues[method])
      ..responseType = responseType;
    // print(options.headers);

    Response response;

    try {
      response = await dio.request(url,
          queryParameters: params, data: data, options: options);
      return _handleResponse(response);
    } on DioException catch (e) {
      return _resultError(e, url);
    } catch (e) {
      return ResultData(e.toString(), false, -1);
    }
  }
}

ResultData _resultError(DioException e, String url) {
  Response? errorResponse;
  if (e.response != null) {
    errorResponse = e.response;
  } else {
    errorResponse =
        Response(statusCode: 999, requestOptions: RequestOptions(path: url));
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    errorResponse!.statusCode = -2;
  }
  return ResultData(e.message, false, errorResponse!.statusCode);
}

ResultData _handleResponse(Response response) {
  return ResultData(response.data, true, response.statusCode);
}

enum DioMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
}
