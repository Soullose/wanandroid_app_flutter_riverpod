import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'router_path.dart';

part 'router_notifier.g.dart';

@riverpod
class RouterNotifier extends _$RouterNotifier implements Listenable {
  VoidCallback? routerListener;

  @override
  FutureOr<void> build() {
    ref.listenSelf((previous, next) {
      if (state.isLoading) return;
      routerListener?.call();
    });
  }

  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    if (this.state.isLoading || this.state.hasError) return null;

    // final isSplash = state.location == RouterPath.welcome.path;
    //
    // if (isSplash) {
    //   // if(isSplash)return RouterPath.welcome.path;
    //   // await Future.delayed(const Duration(seconds: 3));
    //   // print('object');
    //   // return RouterPath.home.path;
    //
    //   Timer(const Duration(seconds: 3), () => RouterPath.home.path);
    // } else {
    //   return null;
    // }

    final isSetting = state.uri.toString() == RouterPath.setting.path;
    if (isSetting) {
      return RouterPath.setting.path;
    }
    return null;
  }

  @override
  void addListener(VoidCallback listener) {
    routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    routerListener = null;
  }
}
