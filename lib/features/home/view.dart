import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_list.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/domain/entities/article_state.dart';
import 'package:wanandroid_app_flutter_riverpod/features/article/presentation/widgets/article_widgets.dart';
import 'package:wanandroid_app_flutter_riverpod/features/home/provider/article_list_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/shared/widgets/responsive/responsive_builder.dart';

import '../article/presentation/providers/articles_provider.dart'
    as article_provider;
import '../banner/presentation/screens/banner_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;
    final showFabNotifierProvider = ref.read(showFabProvider.notifier);
    if (currentOffset > 300) {
      showFabNotifierProvider.enableFab();
    } else {
      showFabNotifierProvider.disableFab();
    }
  }

  // 处理滚动通知
  bool _handleScrollNotification(ScrollNotification notification) {
    final articleNotifierProvider = ref.read(
      article_provider.articlesProvider.notifier,
    );

    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
        if (kDebugMode) {
          debugPrint('加载更多数据');
        }
        articleNotifierProvider.loadMore();
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final showFabNotifierProvider = ref.read(showFabProvider.notifier);
    final articleNotifierProvider = ref.read(
      article_provider.articlesProvider.notifier,
    );
    final articleState = ref.watch(article_provider.articlesProvider);

    return ResponsiveBuilder(
      mobile: _buildMobileLayout(
        context,
        ref,
        _scrollController,
        _listKey,
        articleState,
        _handleScrollNotification,
        articleNotifierProvider,
        showFabNotifierProvider,
      ),
      smallTablet: _buildTabletLayout(
        context,
        ref,
        _scrollController,
        _listKey,
        articleState,
        _handleScrollNotification,
        articleNotifierProvider,
        showFabNotifierProvider,
        crossAxisCount: 2,
      ),
      largeTablet: _buildTabletLayout(
        context,
        ref,
        _scrollController,
        _listKey,
        articleState,
        _handleScrollNotification,
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
                builder: (_, WidgetRef ref, _) => articleState.when(
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
                builder: (_, WidgetRef ref, _) => articleState.when(
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
