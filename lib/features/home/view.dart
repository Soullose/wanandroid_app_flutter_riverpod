import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_state.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/presentation/widgets/article_widgets.dart';
import 'package:wanandroid_app_flutter_riverpod/features/home/provider/article_list_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_load_status.dart';
import '../article/presentation/providers/article_load_state_provider.dart';
import '../article/presentation/providers/articles_provider.dart'
    as article_provider;
import '../banner/presentation/screens/banner_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  Timer? _debounceTimer;
  static const double _loadMoreThreshold = 250.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;
    final showFabNotifier = ref.read(showFabProvider.notifier);
    if (currentOffset > 300) {
      showFabNotifier.enableFab();
    } else {
      showFabNotifier.disableFab();
    }

    // 触底检测 —— 距底部 250px 时触发加载更多
    _checkAndLoadMore();
  }

  void _checkAndLoadMore() {
    final position = _scrollController.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }

    final distanceToBottom = position.maxScrollExtent - position.pixels;
    if (distanceToBottom <= _loadMoreThreshold) {
      _debouncedLoadMore();
    }
  }

  void _debouncedLoadMore() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      ref.read(article_provider.articlesProvider.notifier).loadMore();
    });
  }

  void _onRetry() {
    ref.read(article_provider.articlesProvider.notifier).loadMore();
  }

  @override
  Widget build(BuildContext context) {
    final showFab = ref.watch(showFabProvider);

    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context, showFab),
      smallTablet: _buildTabletLayout(context, showFab, crossAxisCount: 2),
      largeTablet: _buildTabletLayout(context, showFab, crossAxisCount: 3),
    );
  }

  /// 手机布局：单列列表
  Widget _buildMobileLayout(BuildContext context, bool showFab) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(article_provider.articlesProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          cacheExtent: 500,
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
              builder: (_, WidgetRef ref, _) {
                final articleAsync = ref.watch(
                  article_provider.articlesProvider.select(
                    (value) => value.value,
                  ),
                );
                final loadStatus = ref.watch(articleLoadStateProvider);

                if (articleAsync == null) {
                  return ref.watch(article_provider.articlesProvider).when(
                    loading: () => _buildSkeletonLoading(),
                    error: (err, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('加载失败: $err'),
                        ),
                      ),
                    ),
                    data: (_) => const SliverToBoxAdapter(child: SizedBox()),
                  );
                }

                final ArticleState data = articleAsync;
                final List<Articles> list = data.articles;

                if (list.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('暂无文章'),
                      ),
                    ),
                  );
                }

                return SliverMainAxisGroup(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final Articles article = list[index];
                          return ArticleCard(
                            article: article,
                            index: index,
                          );
                        },
                        childCount: list.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: true,
                      ),
                    ),
                    // 底部状态区域
                    _buildBottomSliver(loadStatus),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(
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
    bool showFab, {
    required int crossAxisCount,
  }) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(article_provider.articlesProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          cacheExtent: 500,
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
              builder: (_, WidgetRef ref, _) {
                final articleAsync = ref.watch(
                  article_provider.articlesProvider.select(
                    (value) => value.value,
                  ),
                );
                final loadStatus = ref.watch(articleLoadStateProvider);

                if (articleAsync == null) {
                  return ref.watch(article_provider.articlesProvider).when(
                    loading: () => _buildSkeletonLoading(),
                    error: (err, _) => SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text('加载失败: $err'),
                        ),
                      ),
                    ),
                    data: (_) => const SliverToBoxAdapter(child: SizedBox()),
                  );
                }

                final ArticleState data = articleAsync;
                final List<Articles> list = data.articles;

                if (list.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('暂无文章'),
                      ),
                    ),
                  );
                }

                return SliverMainAxisGroup(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverGrid(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (_, int index) {
                            final Articles article = list[index];
                            return ArticleGridCard(
                              article: article,
                              index: index,
                            );
                          },
                          childCount: list.length,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: true,
                        ),
                      ),
                    ),
                    // 底部状态区域
                    _buildBottomSliver(loadStatus),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: showFab
          ? FloatingActionButton(
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                _scrollController.animateTo(
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

  /// 底部加载/错误/提示状态
  Widget _buildBottomSliver(ArticleLoadStatus loadStatus) {
    // 加载更多中
    if (loadStatus.isLoadingMore) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        ),
      );
    }

    // 已到底
    if (loadStatus.hasReachedMax) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              '—— 已经到底了 ——',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    }

    // 加载错误
    if (loadStatus.loadMoreError != null) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Text(
                  '加载失败: ${loadStatus.loadMoreError}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _onRetry,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 正常状态：显示「上拉加载更多」提示
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '上拉加载更多',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// 骨架屏（初始加载）
  SliverToBoxAdapter _buildSkeletonLoading() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 80,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
