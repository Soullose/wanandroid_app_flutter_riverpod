import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../result_data.dart';

/// 响应拦截器
/// 统一处理响应数据，包装为 ResultData
/// 自动提取 WanAndroid API 标准格式中的 data 字段
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    try {
      final statusCode = response.statusCode;
      final headers = response.headers;
      final responseData = response.data;

      // 检查 HTTP 状态码
      if (statusCode != null &&
          statusCode >= HttpStatus.ok &&
          statusCode < HttpStatus.multipleChoices) {
        // 成功响应 (2xx)
        final contentType = headers.value(Headers.contentTypeHeader);
        final isTextResponse = contentType?.contains('text') ?? false;

        // WanAndroid API 标准格式: { data: ..., errorCode: ..., errorMsg: ... }
        // 自动提取嵌套的 data 字段和业务状态码
        if (responseData is Map<String, dynamic>) {
          final apiErrorCode = responseData['errorCode'] as int?;
          final apiErrorMsg = responseData['errorMsg'] as String?;
          final apiData = responseData['data'];

          response.data = ResultData(
            data: apiData,
            success: apiErrorCode == 0,
            code: apiErrorCode ?? statusCode,
            headers: headers,
            message: apiErrorMsg ?? (isTextResponse ? null : '请求成功'),
          );
        } else {
          // 非 Map 类型响应（如纯文本、列表等），保持原样
          response.data = ResultData(
            data: responseData,
            success: true,
            code: statusCode,
            headers: headers,
            message: isTextResponse ? null : '请求成功',
          );
        }
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
