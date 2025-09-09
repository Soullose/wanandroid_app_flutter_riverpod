import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RefreshTokenInterceptors extends QueuedInterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        final options = err.response!.requestOptions;
        print('the token has expired, need to receive new token $options');
      }
    }
    super.onError(err, handler);
  }
}
