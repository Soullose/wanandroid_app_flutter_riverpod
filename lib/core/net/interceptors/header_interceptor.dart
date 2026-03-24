import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../constants/constant.dart';

/// 请求头拦截器配置
class HeaderInterceptorConfig {
  /// 连接超时时间
  final Duration connectTimeout;

  /// 接收超时时间
  final Duration receiveTimeout;

  /// 发送超时时间
  final Duration sendTimeout;

  /// 默认请求头
  final Map<String, String> defaultHeaders;

  const HeaderInterceptorConfig({
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
    this.sendTimeout = const Duration(seconds: 10),
    this.defaultHeaders = const {'Accept': 'application/json'},
  });
}

/// 请求头拦截器
/// 统一处理请求头和超时配置
class HeaderInterceptor extends InterceptorsWrapper {
  final HeaderInterceptorConfig config;

  HeaderInterceptor({this.config = const HeaderInterceptorConfig()});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 设置超时
    options.connectTimeout = config.connectTimeout;
    options.receiveTimeout = config.receiveTimeout;
    options.sendTimeout = config.sendTimeout;
    options.baseUrl = Constant.wanAndroidBaseurl;

    // 添加默认请求头（不覆盖已有头）
    for (final entry in config.defaultHeaders.entries) {
      options.headers.putIfAbsent(entry.key, () => entry.value);
    }

    super.onRequest(options, handler);
  }
}
