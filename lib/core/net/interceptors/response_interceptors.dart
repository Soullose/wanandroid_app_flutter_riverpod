import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../result_data.dart';

/// 响应拦截器
/// 统一处理响应数据，包装为 ResultData
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    try {
      final statusCode = response.statusCode;
      final headers = response.headers;

      // 检查 HTTP 状态码
      if (statusCode != null &&
          statusCode >= HttpStatus.ok &&
          statusCode < HttpStatus.multipleChoices) {
        // 成功响应 (2xx)
        final contentType = headers.value(Headers.contentTypeHeader);
        final isTextResponse = contentType?.contains('text') ?? false;

        response.data = ResultData(
          data: response.data,
          success: true,
          code: statusCode,
          headers: headers,
          message: isTextResponse ? null : '请求成功',
        );
      } else {
        // 非 2xx 状态码
        response.data = ResultData(
          data: response.data,
          success: false,
          code: statusCode ?? -1,
          headers: headers,
          message: '请求失败: ${statusCode ?? "未知状态码"}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ResponseInterceptors error: ${e.toString()}');
      }
      response.data = ResultData(
        data: response.data,
        success: false,
        code: response.statusCode ?? -1,
        message: '响应解析失败: ${e.toString()}',
      );
    }

    super.onResponse(response, handler);
  }
}
