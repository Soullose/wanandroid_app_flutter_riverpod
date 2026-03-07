import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_state.dart';
import 'package:wanandroid_app_flutter_riverpod/features/home/provider/article_list_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/utils/responsive/responsive_helper.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

import '../article/presentation/providers/articles_provider.dart'
    as article_provider;
import '../banner/presentation/screens/banner_screen.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<SliverAnimatedListState> _listKey =
        GlobalKey<SliverAnimatedListState>();
    final showFabNotifierProvider = ref.read(showFabProvider.notifier);
    final ScrollController scrollController = ScrollController();
    final articleNotifierProvider = ref.read(
      article_provider.articlesProvider.notifier,
    );
    final articleState = ref.watch(article_provider.articlesProvider);

    // 处理滚动通知
    bool handleScrollNotification(ScrollNotification notification) {
      if (notification is ScrollStartNotification) {
        // debugPrint('开始滚动');
      } else if (notification is ScrollUpdateNotification) {
        ScrollMetrics metrics = notification.metrics;
        double scrollDelta = notification.scrollDelta!;
        double scrollDistance = metrics.pixels;

        if (scrollDelta > 0) {
          // debugPrint('向下滚动: $scrollDelta');
        } else if (scrollDelta < 0) {
          // debugPrint('向上滚动: $scrollDelta');
        }

        final maxScrollExtent = metrics.maxScrollExtent > 0
            ? metrics.maxScrollExtent
            : 1;
        final scrollPercentage = metrics.pixels / maxScrollExtent;

        bool isNearBottom = metrics.pixels >= metrics.maxScrollExtent - 100;
        if (isNearBottom) {
          // debugPrint('接近底部，可以加载更多数据');
        }
      } else if (notification is ScrollEndNotification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent) {
          if (kDebugMode) {
            print('加载更多数据');
          }
          articleNotifierProvider.loadMore();
        }
      } else if (notification is OverscrollNotification) {
        // debugPrint('过度滚动: ${notification.overscroll}');
      }

      return true;
    }

    scrollController.addListener(() {
      final currentOffset = scrollController.offset;
      if (currentOffset > 300) {
        showFabNotifierProvider.enableFab();
      } else {
        showFabNotifierProvider.disableFab();
      }
    });

    return ResponsiveBuilder(
      mobile: _buildMobileLayout(
        context,
        ref,
        scrollController,
        _listKey,
        articleState,
        handleScrollNotification,
        articleNotifierProvider,
        showFabNotifierProvider,
      ),
      smallTablet: _buildTabletLayout(
        context,
        ref,
        scrollController,
        _listKey,
        articleState,
        handleScrollNotification,
        articleNotifierProvider,
        showFabNotifierProvider,
        crossAxisCount: 2,
      ),
      largeTablet: _buildTabletLayout(
        context,
        ref,
        scrollController,
        _listKey,
        articleState,
        handleScrollNotification,
        articleNotifierProvider,
        showFabNotifierProvider,
        crossAxisCount: 3,
      ),
    );
  }

  /// 手机布局：单列列表
  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    ScrollController scrollController,
    GlobalKey<SliverAnimatedListState> listKey,
    AsyncValue<ArticleState> articleState,
    bool Function(ScrollNotification) handleScrollNotification,
    article_provider.Articles articleNotifierProvider,
    dynamic showFabNotifierProvider,
  ) {
    return Scaffold(
      body: NotificationListener(
        onNotification: (ScrollNotification notification) {
          return handleScrollNotification(notification);
        },
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(articleListProvider.future),
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                title: const Text('首页'),
                backgroundColor: ColorScheme.of(context).inversePrimary,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/search');
                    },
                  ),
                ],
              ),
              const BannerScreen(),
              Consumer(
                builder: (_, WidgetRef ref, __) => articleState.when(
                  data: (ArticleState data) {
                    final List<Articles> list = data.articles;
                    if (kDebugMode) {
                      print('长度:${list.length}');
                    }
                    if (list.isEmpty) {
                      return const SliverToBoxAdapter(child: Text('空'));
                    }
                    return SliverAnimatedList(
                      key: listKey,
                      initialItemCount: list.length,
                      itemBuilder: (context, index, animation) {
                        final Articles article = list[index];
                        return ArticleCard(
                          article: article,
                          index: index,
                          isVisible: true,
                        );
                      },
                    );
                  },
                  error: (err, stack) {
                    return SliverToBoxAdapter(child: Text('Error: $err'));
                  },
                  loading: () {
                    return const SliverToBoxAdapter();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ref.watch(showFabProvider)
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// 平板布局：多列网格
  Widget _buildTabletLayout(
    BuildContext context,
    WidgetRef ref,
    ScrollController scrollController,
    GlobalKey<SliverAnimatedListState> listKey,
    AsyncValue<ArticleState> articleState,
    bool Function(ScrollNotification) handleScrollNotification,
    article_provider.Articles articleNotifierProvider,
    dynamic showFabNotifierProvider, {
    required int crossAxisCount,
  }) {
    return Scaffold(
      body: NotificationListener(
        onNotification: (ScrollNotification notification) {
          return handleScrollNotification(notification);
        },
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(articleListProvider.future),
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverAppBar(
                title: const Text('首页'),
                backgroundColor: ColorScheme.of(context).inversePrimary,
                pinned: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Navigator.pushNamed(context, '/search');
                    },
                  ),
                ],
              ),
              // Banner在平板上居中显示
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const BannerScreen(),
                  ),
                ),
              ),
              Consumer(
                builder: (_, WidgetRef ref, __) => articleState.when(
                  data: (ArticleState data) {
                    final List<Articles> list = data.articles;
                    if (kDebugMode) {
                      print('长度:${list.length}');
                    }
                    if (list.isEmpty) {
                      return const SliverToBoxAdapter(child: Text('空'));
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        delegate: SliverChildBuilderDelegate((_, int index) {
                          final Articles article = list[index];
                          return ArticleGridCard(
                            article: article,
                            index: index,
                            isVisible: true,
                          );
                        }, childCount: list.length),
                      ),
                    );
                  },
                  error: (err, stack) {
                    return SliverToBoxAdapter(child: Text('Error: $err'));
                  },
                  loading: () {
                    return const SliverToBoxAdapter();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ref.watch(showFabProvider)
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// 文章卡片组件（列表样式）
class ArticleCard extends StatefulWidget {
  final Articles article;
  final int index;
  final bool isVisible;

  const ArticleCard({
    super.key,
    required this.article,
    required this.index,
    required this.isVisible,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: widget.isVisible ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _BuildCard(widget: widget),
    );
  }
}

/// 文章网格卡片组件（平板样式）
class ArticleGridCard extends StatefulWidget {
  final Articles article;
  final int index;
  final bool isVisible;

  const ArticleGridCard({
    super.key,
    required this.article,
    required this.index,
    required this.isVisible,
  });

  @override
  State<ArticleGridCard> createState() => _ArticleGridCardState();
}

class _ArticleGridCardState extends State<ArticleGridCard>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: widget.isVisible ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _BuildGridCard(widget: widget),
    );
  }
}

/// 列表卡片内容
class _BuildCard extends StatelessWidget {
  const _BuildCard({required this.widget});

  final ArticleCard widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Handle article tap - maybe open the link
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.article.chapterName ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (widget.article.fresh == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      if (widget.article.tags != null)
                        ...widget.article.tags!.map(
                          (tag) => Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag.name ?? '',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.article.title ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.article.author?.isNotEmpty == true) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          child: Text(
                            widget.article.author![0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.article.author!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ] else if (widget.article.shareUser?.isNotEmpty ==
                          true) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.1),
                          child: Text(
                            widget.article.shareUser![0].toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.article.shareUser!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.article.niceDate ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 网格卡片内容
class _BuildGridCard extends StatelessWidget {
  const _BuildGridCard({required this.widget});

  final ArticleGridCard widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle article tap
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标签行
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.article.chapterName ?? '',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (widget.article.fresh == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                // 标题
                Expanded(
                  child: Text(
                    widget.article.title ?? '',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // 作者和时间
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.article.author?.isNotEmpty == true
                            ? widget.article.author!
                            : widget.article.shareUser ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      widget.article.niceDate ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
