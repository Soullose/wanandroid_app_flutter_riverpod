// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/api/simple.dart';
import 'package:wanandroid_app_flutter_riverpod/src/rust/frb_generated.dart';

import 'common/router/app_router.dart';
import 'common/storage/shared_preferences_provider.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/app_theme_mode.dart';
import 'common/utils/state_logger/state_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  HttpOverrides.global = MyHttpOverrides();
  final prefs = await SharedPreferences.getInstance();
  print('xxx:${greet(name: "Tom")}');
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

// HTTP证书验证覆盖类
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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


// import 'package:flutter/material.dart';
// import 'package:wanandroid_app_flutter_riverpod/src/rust/api/simple.dart';
// import 'package:wanandroid_app_flutter_riverpod/src/rust/frb_generated.dart';
//
// Future<void> main() async {
//   await RustLib.init();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
//         body: Center(
//           child: Text(
//               'Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`'),
//         ),
//       ),
//     );
//   }
// }
