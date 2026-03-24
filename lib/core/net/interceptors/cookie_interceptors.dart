import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/core/services/storage/basic_storage_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/utils/log_utils.dart';

class CookieInterceptors extends QueuedInterceptorsWrapper {
  CookieInterceptors({required this.ref});

  final Ref ref;

  final String requestHeaderKey = 'Cookie';
  final String responseHeaderKey = 'set-cookie';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final cookie = getCookie();
    if (cookie!.isNotEmpty) {
      options.headers[requestHeaderKey] = cookie;
    }
    LogUtils.i(options.headers);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    if (kDebugMode) {
      print(
        'CookieInterceptors.onResponse - path: ${response.requestOptions.path}',
      );
      print(
        'CookieInterceptors.onResponse - statusCode: ${response.statusCode}',
      );
    }
    final cookie = getCookie();
    if (cookie == null || cookie.isEmpty) {
      await saveCookie(response);
    }
    super.onResponse(response, handler);
  }

  Future<void> saveCookie(Response<dynamic> response) async {
    final setCookie = response.headers.map[responseHeaderKey];
    if (kDebugMode) {
      print('CookieInterceptors.saveCookie - setCookie: $setCookie');
    }
    if (setCookie != null && setCookie.isNotEmpty) {
      ref.read(cookieProvider.notifier).updateCookie(setCookie);
    }
  }

  List<String>? getCookie() {
    final cookie = ref.read(cookieProvider);
    return cookie;
  }
}
