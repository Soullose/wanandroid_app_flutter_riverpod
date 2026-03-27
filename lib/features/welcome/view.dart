import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' as rive;

import '../../common/router/router_path.dart';
import '../../core/services/network/network_status.dart';
import '../../core/services/network/network_status_provider.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  Timer? _timer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _checkNetworkAndNavigate();
  }

  /// 检测网络状态并导航
  Future<void> _checkNetworkAndNavigate() async {
    // 等待网络状态检测完成
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final networkStatus = ref.read(networkStatusProvider);

    if (networkStatus.isOffline) {
      // 无网络，跳转到网络错误页面
      _navigateTo(RouterPath.networkError.path);
      return;
    }

    // 有网络，启动定时器后跳转首页
    _startWelcomeTimer();
  }

  /// 启动欢迎页定时器
  void _startWelcomeTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      _navigateTo(RouterPath.home.path);
    });
  }

  /// 安全导航方法
  void _navigateTo(String path) {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    context.go(path);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 监听网络状态变化
    ref.listen<NetworkStatus>(networkStatusProvider, (previous, next) {
      // 如果之前是离线状态，现在变为在线，则跳转到首页
      if (previous?.isOffline == true && next.isOnline) {
        _timer?.cancel();
        _navigateTo(RouterPath.home.path);
      }
    });

    return Material(
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0.0, -0.6),
            child: SizedBox(
              width: 240,
              height: 240,
              child: rive.RiveAnimation.asset(
                'assets/file/birb.riv',
                animations: const ["lookUp"],
                onInit: (arb) {
                  var controller = rive.StateMachineController.fromArtboard(
                    arb,
                    "birb",
                  );
                  var smi = controller?.findInput<bool>("dance");
                  arb.addController(controller!);
                  smi?.value == true;
                },
              ),
            ),
          ),
          const Center(child: Text('欢迎页')),
        ],
      ),
    );
  }
}
