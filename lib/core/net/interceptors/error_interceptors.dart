import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:dio/dio.dart';

import '../result_data.dart';

/// 错误拦截器
/// 处理网络错误和 HTTP 错误
class ErrorInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 检查网络连接
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          type: DioExceptionType.unknown,
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: -1,
            data: const ResultData(
              data: null,
              success: false,
              code: -1,
              message: '网络错误',
            ),
          ),
          message: '网络错误未连接网络',
        ),
      );
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 构建错误信息，但不显示 Toast
    // 由调用方决定如何处理错误
    final errorInfo = _getErrorInfo(err);

    // 将错误信息附加到 exception 中
    final newError = DioException(
      type: err.type,
      requestOptions: err.requestOptions,
      response: err.response,
      message: errorInfo,
    );

    super.onError(newError, handler);
  }

  /// 获取错误信息
  String _getErrorInfo(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        return '连接超时';
      case DioExceptionType.receiveTimeout:
        return '接收数据超时';
      case DioExceptionType.sendTimeout:
        return '发送数据超时';
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == HttpStatus.unauthorized) {
          return '登录过期，请重新登录';
        } else if (statusCode == HttpStatus.forbidden) {
          return '没有权限访问';
        } else if (statusCode == HttpStatus.notFound) {
          return '请求的资源不存在';
        } else if (statusCode == HttpStatus.internalServerError) {
          return '服务器内部错误';
        } else if (statusCode == HttpStatus.badGateway) {
          return '网关错误';
        } else if (statusCode == HttpStatus.serviceUnavailable) {
          return '服务暂时不可用';
        } else if (statusCode == HttpStatus.gatewayTimeout) {
          return '网关超时';
        }
        return '网络请求出错 (${statusCode ?? "未知"})';
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        return '网络连接失败，请检查网络设置';
      case DioExceptionType.badCertificate:
        return '证书验证失败';
      case DioExceptionType.unknown:
        return err.message ?? '未知错误';
    }
  }
}
