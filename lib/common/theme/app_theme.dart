import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// class AppTheme {
//   const AppTheme._();

//   //  light 样式
//   static ThemeData light() {
//     final FlexColorScheme flexColorScheme = FlexColorScheme.light(
//       // scheme: FlexScheme.aquaBlue,
//       scheme: FlexScheme.material,
//       // colors: _light,
//       surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
//       blendLevel: 7,
//       // subThemesData: const FlexSubThemesData(
//       //   blendOnLevel: 10,
//       //   blendOnColors: false,
//       //   useTextTheme: true,
//       //   useM2StyleDividerInM3: true,
//       // ),
//       subThemesData: const FlexSubThemesData(
//         interactionEffects: false,
//         tintedDisabledControls: false,
//         useTextTheme: true,
//         inputDecoratorBorderType: FlexInputBorderType.underline,
//         inputDecoratorUnfocusedBorderIsColored: false,
//         tooltipRadius: 4,
//         tooltipSchemeColor: SchemeColor.inverseSurface,
//         tooltipOpacity: 0.9,
//         snackBarElevation: 6,
//         snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
//         navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationBarMutedUnselectedLabel: false,
//         navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
//         navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
//         navigationBarMutedUnselectedIcon: false,
//         navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
//         navigationBarIndicatorOpacity: 1.00,
//         navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationRailMutedUnselectedLabel: false,
//         navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
//         navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
//         navigationRailMutedUnselectedIcon: false,
//         navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
//         navigationRailIndicatorOpacity: 1.00,
//         navigationRailBackgroundSchemeColor: SchemeColor.surface,
//         navigationRailLabelType: NavigationRailLabelType.none,
//       ),
//       keyColors: const FlexKeyColors(
//         useSecondary: true,
//         useTertiary: true,
//       ),
//       // useMaterial3ErrorColors: true,
//       visualDensity: FlexColorScheme.comfortablePlatformDensity,
//       useMaterial3: true,
//       swapLegacyOnMaterial3: true,
//     );

//     return flexColorScheme.toTheme;
//   }

//   //  dark 样式
//   static ThemeData dark() {
//     final FlexColorScheme flexColorScheme = FlexColorScheme.dark(
//       // scheme: FlexScheme.aquaBlue,
//       scheme: FlexScheme.material,
//       // colors: _dark,
//       surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
//       blendLevel: 13,
//       // subThemesData: const FlexSubThemesData(
//       //   blendOnLevel: 20,
//       //   useTextTheme: true,
//       //   useM2StyleDividerInM3: true,
//       // ),
//       subThemesData: const FlexSubThemesData(
//         interactionEffects: false,
//         tintedDisabledControls: false,
//         useTextTheme: true,
//         inputDecoratorBorderType: FlexInputBorderType.underline,
//         inputDecoratorUnfocusedBorderIsColored: false,
//         tooltipRadius: 4,
//         tooltipSchemeColor: SchemeColor.inverseSurface,
//         tooltipOpacity: 0.9,
//         snackBarElevation: 6,
//         snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
//         navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationBarMutedUnselectedLabel: false,
//         navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
//         navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
//         navigationBarMutedUnselectedIcon: false,
//         navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
//         navigationBarIndicatorOpacity: 1.00,
//         navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
//         navigationRailMutedUnselectedLabel: false,
//         navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
//         navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
//         navigationRailMutedUnselectedIcon: false,
//         navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
//         navigationRailIndicatorOpacity: 1.00,
//         navigationRailBackgroundSchemeColor: SchemeColor.surface,
//         navigationRailLabelType: NavigationRailLabelType.none,
//       ),
//       keyColors: const FlexKeyColors(
//         useSecondary: true,
//         useTertiary: true,
//       ),
//       // useMaterial3ErrorColors: true,
//       visualDensity: FlexColorScheme.comfortablePlatformDensity,
//       useMaterial3: true,
//       swapLegacyOnMaterial3: true,
//     );

//     return flexColorScheme.toTheme;
//   }

//   static const FlexSchemeColor _light = FlexSchemeColor(
//     primary: Color(0xff004881),
//     primaryContainer: Color(0xffd0e4ff),
//     secondary: Color(0xffac3306),
//     secondaryContainer: Color(0xffffdbcf),
//     tertiary: Color(0xff006875),
//     tertiaryContainer: Color(0xff95f0ff),
//     appBarColor: Color(0xffffdbcf),
//     error: Color(0xffb00020),
//   );

//   static const FlexSchemeColor _dark = FlexSchemeColor(
//     primary: Color(0xff9fc9ff),
//     primaryContainer: Color(0xff00325b),
//     secondary: Color(0xffffb59d),
//     secondaryContainer: Color(0xff872100),
//     tertiary: Color(0xff86d2e1),
//     tertiaryContainer: Color(0xff004e59),
//     appBarColor: Color(0xff872100),
//     error: Color(0xffcf6679),
//   );

//   static const FlexSchemeColor _aquaBlueLight = FlexSchemeColor(
//     primary: Color(0xff35a0cb),
//     primaryContainer: Color(0xff71d3ed),
//     secondary: Color(0xff89d1c8),
//     secondaryContainer: Color(0xff91f4e8),
//     tertiary: Color(0xff61d4d4),
//     tertiaryContainer: Color(0xff8ff3f2),
//     appBarColor: Color(0xff91f4e8),
//     error: Color(0xffb00020),
//   );

//   static const FlexSchemeColor _aquaBlueDart = FlexSchemeColor(
//     primary: Color(0xff5db3d5),
//     primaryContainer: Color(0xff297ea0),
//     secondary: Color(0xffa1e9df),
//     secondaryContainer: Color(0xff005049),
//     tertiary: Color(0xffa0e5e5),
//     tertiaryContainer: Color(0xff004f50),
//     appBarColor: Color(0xff005049),
//     error: Color(0xffcf6679),
//   );
// }

final lightThemeProvider = Provider((ref) => FlexThemeData.light(
      scheme: FlexScheme.purpleBrown,
      appBarElevation: 0.5,
      typography: Typography.material2021(platform: defaultTargetPlatform),
    ));

final darkThemeProvider = Provider((ref) => FlexThemeData.dark(
      scheme: FlexScheme.purpleBrown,
      appBarElevation: 0.5,
      typography: Typography.material2021(platform: defaultTargetPlatform),
    ));
