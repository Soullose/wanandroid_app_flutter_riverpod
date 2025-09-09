import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/banner/presentation/providers/banner_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/features/home/provider/article_list_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/model/article/article_list.dart';

import '../banner/presentation/screens/banner_screen.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerFutureProvider = ref.watch(bannerProvider);
    final articleState = ref.watch(articleListProvider);
    final carouselController = CarouselSliderController();
    final articleListNotifierProvider = ref.read(articleListProvider.notifier);
    final showFabNotifierProvider = ref.read(showFabProvider.notifier);
    final ScrollController scrollController = ScrollController();
    final listKey = articleListNotifierProvider.animatedListKey;
    // 处理滚动通知
    bool handleScrollNotification(ScrollNotification notification) {
      // 记录滚动信息
      // double scrollDistance = 0;
      // ScrollMetrics metrics;
      // double scrollDelta = 0.0;
      // bool isNearBottom = false;
      // 开始滚动
      if (notification is ScrollStartNotification) {
        // debugPrint('开始滚动');
      }

      // 滚动过程中
      else if (notification is ScrollUpdateNotification) {
        ScrollMetrics metrics = notification.metrics;
        double scrollDelta = notification.scrollDelta!;

        // 更新滚动距离
        double scrollDistance = metrics.pixels;

        // 判断滚动方向
        if (scrollDelta > 0) {
          // debugPrint('向下滚动: $scrollDelta');
        } else if (scrollDelta < 0) {
          // debugPrint('向上滚动: $scrollDelta');
        }

        // 计算滚动百分比
        final maxScrollExtent =
            metrics.maxScrollExtent > 0 ? metrics.maxScrollExtent : 1;
        final scrollPercentage = metrics.pixels / maxScrollExtent;
        // debugPrint('滚动百分比: ${(scrollPercentage * 100).toStringAsFixed(2)}%');

        // 检查是否接近底部
        bool isNearBottom = metrics.pixels >= metrics.maxScrollExtent - 100;
        if (isNearBottom) {
          // debugPrint('接近底部，可以加载更多数据');
          // articleListNotifierProvider.fetchNewArticles();
        }
      }

      // 滚动结束
      else if (notification is ScrollEndNotification) {
        // debugPrint('结束滚动，最终位置: $scrollDistance');
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent) {
          if (kDebugMode) {
            print('加载更多数据');
          }
          articleListNotifierProvider.fetchNewArticles();
        }
      }

      // 处理过度滚动
      else if (notification is OverscrollNotification) {
        // debugPrint('过度滚动: ${notification.overscroll}');
      }

      // 返回true表示消费掉这个通知，不再向上冒泡
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

    // if (articleState.isLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

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
                  title: Text('首页'),
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
                BannerScreen(),
                Consumer(
                  builder: (_, WidgetRef ref, __) => articleState.when(
                    data: (data) {
                      // EasyLoading.dismiss();
                      final List<Articles> list = data;
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

                      //   SliverList(
                      //   delegate: SliverChildBuilderDelegate(
                      //     (_, int index) {
                      //       final Articles article = list[index];
                      //       // widget.header
                      //       return ArticleCard(
                      //         article: article,
                      //         index: index,
                      //         isVisible: true,
                      //       );
                      //     },
                      //     childCount: list.length,
                      //   ),
                      // );
                    },
                    error: (err, stack) {
                      // EasyLoading.dismiss();
                      return SliverToBoxAdapter(child: Text('Error: $err'));
                    },
                    loading: () {
                      // EasyLoading.instance.indicatorType =
                      //     EasyLoadingIndicatorType.cubeGrid;
                      // EasyLoading.show();
                      return const SliverToBoxAdapter();
                    },
                  ),
                ),
              ],
            ),
          )),
      floatingActionButton: ref.watch(showFabProvider)
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                scrollController.animateTo(
                  0.0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ArticleCard extends StatefulWidget {
  final Articles article;
  final int index;
  final bool isVisible; // 控制卡片是否显示的标志

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
      tween: Tween<double>(
        begin: 0.0,
        end: widget.isVisible ? 1.0 : 0.0,
      ),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: _BuildCard(
        widget: widget,
      ),
    );
  }
}

class _BuildCard extends StatelessWidget {
  const _BuildCard({
    required this.widget,
  });

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
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.article.chapterName!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (widget.article.fresh!) ...[
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
                              tag.name!,
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
                    widget.article.title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.article.author!.isNotEmpty) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
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
                      ] else if (widget.article.shareUser!.isNotEmpty) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
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
                        widget.article.niceDate!,
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
