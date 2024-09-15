import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wanandroid_app_flutter_riverpod/modules/home/provider/article_list_provider.dart';
import 'package:wanandroid_app_flutter_riverpod/modules/home/provider/banner_provider.dart';


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
        const SliverAppBar(
          title: Text('首页'),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 2),
            alignment: Alignment.bottomCenter,
            child: bannerFutureProvider.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (data) {
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
                        if (kDebugMode) {
                          print('----:$index');
                        }
                      }), //height: 190.0
                );
              },
            ),
          ),
        ),
        // Consumer(
        //   builder: (_, WidgetRef ref, __) =>
        //       ref.watch(articleListProvider).when(
        //             data: (data) {
        //               final List<Articles> list = data;
        //
        //               if (list.isEmpty) {
        //                 return const SliverFillRemaining(child: Text('空'));
        //               }
        //               return SliverList(
        //                 delegate: SliverChildBuilderDelegate(
        //                   (_, int index) {
        //                     final Articles article = list[index];
        //
        //                     return Text(article.title!);
        //                   },
        //                   childCount: list.length,
        //                 ),
        //               );
        //             },
        //             error: (err, stack) =>
        //                 SliverToBoxAdapter(child: Text('Error: $err')),
        //             loading: () {
        //               EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
        //               EasyLoading.show();
        //               return const CupertinoActivityIndicator();
        //             },
        //           ),
        // ),
      ],
    );
  }
}
