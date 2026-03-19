import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_app_flutter_riverpod/core/services/logger/file_logger_service.dart';
import 'package:wanandroid_app_flutter_riverpod/features/logger/model/log_level.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/utils/state_logger/state_logger.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/simple.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/sysinfo.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/frb_generated.dart';

import 'app.dart';
import 'core/services/storage/shared_preferences_provider.dart';

Future<void> bootstrap() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志服务
  final fileLoggerService = FileLoggerService();
  await fileLoggerService.initialize();

  // 捕获 Flutter 框架错误
  FlutterError.onError = (details) {
    // 在调试模式下打印到控制台
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }

    // 记录到文件日志
    fileLoggerService
        .logError(
          details.exception,
          details.stack,
          level: LogLevel.crash,
          additionalData: {
            'context': details.context?.toString(),
            'library': details.library,
            'silent': details.silent,
          },
        )
        .then((_) {
          if (kDebugMode) {
            log('Flutter error logged to file');
          }
        })
        .catchError((e) {
          if (kDebugMode) {
            log('Failed to log Flutter error: $e');
          }
        });
  };

  // 捕获所有 Dart 异步错误（Flutter 3.3+ 现代方式）
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    // 在调试模式下打印到控制台
    if (kDebugMode) {
      log(
        'Uncaught error: $error',
        stackTrace: stackTrace,
        level: 1000, // SEVERE
      );
    }

    // 记录到文件日志
    fileLoggerService
        .logError(error, stackTrace, level: LogLevel.crash)
        .then((_) {
          if (kDebugMode) {
            log('Uncaught error logged to file');
          }
        })
        .catchError((e) {
          if (kDebugMode) {
            log('Failed to log uncaught error: $e');
          }
        });

    // 返回 true 表示已处理
    return true;
  };

  // 配置 logging 包
  if (kReleaseMode) {
    // 发布模式下只记录警告及以上级别
    Logger.root.level = Level.WARNING;
  }
  Logger.root.onRecord.listen((record) {
    debugPrint(
      '${record.level.name}: ${record.time}: '
      '${record.loggerName}: '
      '${record.message}',
    );

    // 将严重错误也记录到文件
    if (record.level >= Level.SEVERE) {
      fileLoggerService.logError(
        record.message,
        record.stackTrace,
        level: record.level >= Level.SHOUT ? LogLevel.crash : LogLevel.error,
        additionalData: {
          'loggerName': record.loggerName,
          'level': record.level.name,
        },
      );
    }
  });

  /// 在发布模式下禁用debugPrint
  if (kReleaseMode) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    debugPrint = (message, {wrapWidth}) {
      /// 发布模式下的空实现，不输出任何调试信息
    };
  }

  log('初始化依赖');

  /// 并行初始化非依赖项
  await Future.wait([
    // initHive(),
    // initFirebase(),
    // initAnalytics(),
  ]);

  await RustLib.init();
  HttpOverrides.global = MyHttpOverrides();
  final prefs = await SharedPreferences.getInstance();

  if (kDebugMode) {
    print('greet:${greet(name: "Tom")}');
    print('cpuArch:${cpuArch()}');
    print('systemName:${systemName()}');
    print('longOsVersion:${longOsVersion()}');
  }

  runApp(
    ProviderScope(
      observers: [StateLogger()],
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: App(),
    ),
  );
}

// HTTP证书验证覆盖类
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
