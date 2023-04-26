import 'package:dio/dio.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/result_data.dart';

import 'interceptors/error_interceptors.dart';
import 'interceptors/header_interceptor.dart';
import 'interceptors/response_interceptors.dart';
import 'interceptors/token_interceptors.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  final dio = Dio();

  HttpManager() {
    dio.interceptors.add(HeaderInterceptors());
    dio.interceptors.add(TokenInterceptors());
    dio.interceptors.add(ErrorInterceptors());
    dio.interceptors.add(ResponseInterceptors());
  }

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
      }) async {
    const _methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };
    options ??= Options(method: _methodValues[method]);
    // print(options.headers);

    resultError(DioError e) {
      Response? errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(
            statusCode: 999, requestOptions: RequestOptions(path: url));
      }
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        errorResponse!.statusCode = -2;
      }
      return ResultData(e.message, false, errorResponse!.statusCode);
    }

    Response response;

    try {
      response = await dio.request(url,
          queryParameters: params, data: data, options: options);
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }

    return response.data;
  }
}

final HttpManager httpManager = HttpManager();

enum DioMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
}