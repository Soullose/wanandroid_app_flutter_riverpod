import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/result_data.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    RequestOptions option = response.requestOptions;

    var value;

    try {
      var header = response.headers[Headers.contentTypeHeader];
      if (handler != null && header.toString().contains("text")) {
        value = ResultData(response.data, true, response.statusCode);
      } else if (response.statusCode! >= 200 && response.statusCode! < 300) {
        value = ResultData(response.data, true, response.statusCode,
            headers: response.headers);
      } else {}
    } catch (e) {
      print('${e.toString()}${option.path}');
      value = ResultData(response.data, false, response.statusCode);
    }
    response.data = value;
    super.onResponse(response, handler);
  }
}
