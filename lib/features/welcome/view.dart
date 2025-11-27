import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' as rive;
import 'package:wanandroid_app_flutter_riverpod/common/router/router_path.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  ConsumerState createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
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
    return Material(
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0.0, -0.6),
            child: SizedBox(
              width: 240,
              height: 240,
              child: rive.RiveAnimation.asset(
                'assets/file/birb.riv',
                animations: const ["lookUp"],
                onInit: (arb) {
                  var controller =
                      rive.StateMachineController.fromArtboard(arb, "birb");
                  var smi = controller?.findInput<bool>("dance");
                  arb.addController(controller!);
                  smi?.value == true;
                },
              ),
            ),
          ),
          Center(
            child: Text('欢迎页'),
          ),
        ],
      ),
    );
  }
}
