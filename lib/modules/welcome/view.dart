import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/router/router_path.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), () {
      context.go(RouterPath.home.path);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 取消定时器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Stack(
        children: [
          Center(
            child: Text('欢迎页'),
          )
        ],
      ),
    );
  }
}
