import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/router/app_router.dart';
import 'common/storage/shared_preferences_provider.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/app_theme_mode.dart';
import 'common/utils/state_logger/state_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpClient().badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    // 根据需要处理证书验证逻辑
    final v = cert.subject.toLowerCase().endsWith('*.wanandroid.com') &&
        host.toLowerCase().endsWith('.wanandroid.com');
    return true; // 只用于测试环境，生产环境中应严格验证证书
  };
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      observers: const [StateLogger()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'wanAndroid',
          debugShowCheckedModeBanner: false,
          theme: ref.watch(lightThemeProvider),
          darkTheme: ref.watch(darkThemeProvider),
          themeMode: themeMode.value,
          routerConfig: router,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
