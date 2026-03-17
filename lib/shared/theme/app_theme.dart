import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 亮色主题 Provider
final lightThemeProvider = Provider(
  (ref) => FlexThemeData.light(
    scheme: FlexScheme.purpleBrown,
    appBarElevation: 0.5,
    typography: Typography.material2021(platform: defaultTargetPlatform),
  ),
);

/// 暗色主题 Provider
final darkThemeProvider = Provider(
  (ref) => FlexThemeData.dark(
    scheme: FlexScheme.purpleBrown,
    appBarElevation: 0.5,
    typography: Typography.material2021(platform: defaultTargetPlatform),
  ),
);
