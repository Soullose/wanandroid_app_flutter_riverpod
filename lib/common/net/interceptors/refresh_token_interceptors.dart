import 'package:dio/dio.dart';

class RefreshTokenInterceptors extends QueuedInterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print('the token has expired, need to receive new token');
      final options = err.response!.requestOptions;
    }
    super.onError(err, handler);
  }
}
