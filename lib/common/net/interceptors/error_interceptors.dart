import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../result_data.dart';

class ErrorInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //没有网络
    // bool isConnectivity = await BasicUtils.checkConnectivity();
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return handler.reject(
        DioError(
            type: DioErrorType.unknown,
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: -1,
              data: ResultData("网络错误", false, -1),
            ),
            message: "网络错误未连接网络"),
      );
      // handler.resolve(response)
      // return handler.reject(DioError(
      //     requestOptions: options,
      //     type: DioErrorType.unknown,
      //     response: Response(
      //       statusCode: -1,
      //       requestOptions: options,
      //       data: ResultData("网络错误", false, -1),
      //     )));
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    String errorDescription = "";

    if (err.type == DioErrorType.connectionTimeout) {
      errorDescription = "连接超时";
    } else if (err.type == DioErrorType.receiveTimeout) {
      errorDescription = "接收数据超时";
    } else if (err.type == DioErrorType.sendTimeout) {
      errorDescription = "发送数据超时";
    } else if (err.type == DioErrorType.badResponse) {
      if (err.response!.statusCode == 401) {
        errorDescription = "登录过期，请重新登录";
      } else if (err.response!.statusCode == 500) {
        errorDescription = "服务器内部错误";
      } else {
        errorDescription = "网络请求出错";
      }
    } else if (err.type == DioErrorType.cancel) {
      errorDescription = "请求已取消";
    } else {
      errorDescription = "网络请求出错";
    }
    // Fluttertoast.showToast(
    //     msg: errorDescription,
    //     fontSize: 16.sp,
    //     backgroundColor: Colors.white,
    //     textColor: Colors.black,
    //     gravity: ToastGravity.CENTER);
    super.onError(err, handler);
  }
}
