import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../storage/basic_storage_provider.dart';

class TokenInterceptors extends QueuedInterceptorsWrapper {
  TokenInterceptors({required this.ref});

  final Ref ref;

  final String headerKey = 'authorization';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authorizationCode = getToken();
    if (kDebugMode) {
      print('-------$authorizationCode');
    }
    if (authorizationCode!.isNotEmpty) {
      options.headers[headerKey] = authorizationCode;
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final authorizationCode = getToken();
    if (authorizationCode!.isEmpty) {
      saveAuthorization(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      if (kDebugMode) {
        print('the token has expired, need to receive new token');
      }
      // final options = err.response!.requestOptions;
    }
    super.onError(err, handler);
  }

  void saveAuthorization(Response<dynamic> response) async {
    final String authorization = response.headers.value(headerKey)!;
    if (kDebugMode) {
      print('token:$authorization');
    }
    final token = ref.read(tokenProvider.notifier);
    token.state = authorization;
  }

  String? getToken() {
    final token = ref.read(tokenProvider.notifier);
    return token.state;
  }
}
