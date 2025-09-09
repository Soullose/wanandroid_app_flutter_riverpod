import 'package:dio/dio.dart';

import '../../constants/constant.dart';

///
///header拦截器
///Created by guoshuyu
/// on 2019/3/23.
///
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //设置baseUrl
    options.baseUrl = Constant.wanAndroidBaseurl;

    ///超时
    options.connectTimeout = const Duration(seconds: 3);
    options.receiveTimeout = const Duration(seconds: 3);

    super.onRequest(options, handler);
  }
}
