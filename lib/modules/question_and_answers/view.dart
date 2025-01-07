import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class QuestionAndAnswersPage extends ConsumerWidget {
  const QuestionAndAnswersPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(
        child: Text('问答'),
      ),
    );
  }
}
