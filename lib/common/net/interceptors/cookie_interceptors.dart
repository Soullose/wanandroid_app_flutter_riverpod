import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../storage/basic_storage_provider.dart';
import '../../utils/log_utils.dart';

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
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final cookie = getCookie();
    if (cookie!.isEmpty) {
      saveCookie(response);
    }
    super.onResponse(response, handler);
  }

  void saveCookie(Response<dynamic> response) async {
    final setCookie = response.headers.map[responseHeaderKey]!;
    if (kDebugMode) {
      print('cookie:$setCookie');
    }
    final cookie = ref.read(cookieProvider.notifier);
    cookie.state = setCookie;
  }

  List<String>? getCookie() {
    final cookie = ref.read(cookieProvider.notifier);
    return cookie.state;
  }
}
