import 'package:dio/dio.dart';

class TokenInterceptors extends QueuedInterceptorsWrapper {
  // String? _token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // final authorizationCode = UserStore.to.token;
    // if(authorizationCode != null){
    //   options.headers['authorization'] = authorizationCode;
    // }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    // if (UserStore.to.token == "") {
    //   saveAuthorization(response);
    // }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print('the token has expired, need to receive new token');
      final options = err.response!.requestOptions;
    }
  }

  void saveAuthorization(Response<dynamic> response) {
    print('token:${response.headers.value('authorization')}');
    // UserStore.to
    //     .setAuthorization(response.headers.value('authorization') ?? '');
  }
}
