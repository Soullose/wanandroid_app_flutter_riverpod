import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/utils/state_logger/state_logger.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/simple.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/sysinfo.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/frb_generated.dart';

import 'app.dart';
import 'core/services/storage/shared_preferences_provider.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (details) {
      log(details.exceptionAsString(), stackTrace: details.stack);
    };
    if (kReleaseMode) {
      // Don't log anything below warnings in production.
      Logger.root.level = Level.WARNING;
    }
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: '
          '${record.loggerName}: '
          '${record.message}');
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
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    // LicenseRegistry.addLicense(() async* {
    //   final license = await rootBundle.loadString('google_fonts/OFL.txt');
    //   yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    // });
    // GoogleFonts.config.allowRuntimeFetching = false;
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
        overrides: [
          // sharedPreferencesProvider,
          // sharedPreferencesAsyncProvider,
          // sharedPreferencesServiceProvider,
          // settingRepositoryProvider,
          // dioAuthRepositoryProvider
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: App(),
      ),
    );
  }, (error, stackTrace) {});
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
