import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NaviPage extends ConsumerWidget {
  const NaviPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text('导航'),
      ),
    );
  }
}
