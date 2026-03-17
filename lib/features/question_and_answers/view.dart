import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/webview_page.dart';

class QuestionAndAnswersPage extends ConsumerWidget {
  const QuestionAndAnswersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveBuilder(
        mobile: _buildMobileLayout(context),
        smallTablet: _buildTabletLayout(context, crossAxisCount: 2),
        largeTablet: _buildTabletLayout(context, crossAxisCount: 3),
      ),
    );
  }

  /// 手机布局
  Widget _buildMobileLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('问答'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildQuestionItem(context, index),
            childCount: 10,
          ),
        ),
      ],
    );
  }

  /// 平板布局
  Widget _buildTabletLayout(
    BuildContext context, {
    required int crossAxisCount,
  }) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('问答'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
          pinned: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, int index) => _buildQuestionGridItem(context, index),
              childCount: 10,
            ),
          ),
        ),
      ],
    );
  }

  /// 问题列表项
  Widget _buildQuestionItem(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.1),
          child: Text('${index + 1}'),
        ),
        title: Text('问题标题 ${index + 1}'),
        subtitle: Text('问题描述 ${index + 1}'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _openQuestionDetail(context);
        },
      ),
    );
  }

  /// 问题网格项
  Widget _buildQuestionGridItem(BuildContext context, int index) {
    return Card(
      child: InkWell(
        onTap: () {
          _openQuestionDetail(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '问题标题 ${index + 1}',
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  '问题描述 ${index + 1}',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 打开问题详情
  void _openQuestionDetail(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const WebViewPage(
          url: 'https://www.wanandroid.com/wenda',
          title: '问答详情',
        ),
      ),
    );
  }
}
