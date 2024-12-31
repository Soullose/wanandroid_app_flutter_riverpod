import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/modules/home/provider/article_list_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/modules/home/provider/banner_provider.dart';

import '../../model/models.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerFutureProvider = ref.watch(bannerProvider);
    final carouselController = CarouselSliderController();
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('首页'),
          backgroundColor: ColorScheme.of(context).inversePrimary,
        ),
        SliverToBoxAdapter(
          child: LayoutBuilder(
            builder: (context, constraints) => Container(
              width: constraints.maxWidth,
              // padding: const EdgeInsets.only(top: 2),
              alignment: Alignment.bottomCenter,
              child: bannerFutureProvider.when(
                loading: () {
                  EasyLoading.instance.indicatorType =
                      EasyLoadingIndicatorType.ring;
                  EasyLoading.show();
                  return const Center();
                },
                error: (err, stack) {
                  EasyLoading.dismiss();
                  return Text('Error: $err');
                },
                data: (data) {
                  EasyLoading.dismiss();
                  return CarouselSlider(
                    carouselController: carouselController,
                    items: data
                        .map((e) => Center(
                              child: Image.network(
                                e.imagePath!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                // width: 1000,
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 2,
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          // if (kDebugMode) {
                          //   print('----:$index');
                          // }
                        }), //height: 190.0
                  );
                },
              ),
            ),
          ),
        ),
        Consumer(
          builder: (_, WidgetRef ref, __) =>
              ref.watch(articleListProvider).when(
            data: (data) {
              EasyLoading.dismiss();
              final List<Articles>? list = data as List<Articles>?;

              if (list!.isEmpty) {
                return const SliverToBoxAdapter(child: Text('空'));
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    final Articles article = list[index];

                    return ArticleCard(article: article, index: index);
                  },
                  childCount: list.length,
                ),
              );
            },
            error: (err, stack) {
              EasyLoading.dismiss();
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
    );
  }
}

class ArticleCard extends StatefulWidget {
  final Articles article;
  final int index;

  const ArticleCard({
    Key? key,
    required this.article,
    required this.index,
  }) : super(key: key);

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(
      Duration(milliseconds: widget.index * 100),
      () {
        if (mounted && _controller != null) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
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
                          ...widget.article.tags!
                              .map((tag) => Padding(
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
                                  ))
                              .toList(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.article.title!,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
        ),
      ),
    );
  }
}
