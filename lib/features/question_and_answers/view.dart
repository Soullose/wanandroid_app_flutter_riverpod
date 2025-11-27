import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
