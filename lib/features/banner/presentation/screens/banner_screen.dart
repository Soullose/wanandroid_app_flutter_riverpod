import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/features/banner/presentation/providers/banner_provider.dart';

class BannerScreen extends ConsumerStatefulWidget {
  const BannerScreen({super.key});

  @override
  ConsumerState createState() => _BannerScreenState();
}

class _BannerScreenState extends ConsumerState<BannerScreen> {
  @override
  Widget build(BuildContext context) {
    final carouselController = CarouselSliderController();
    final bannerFutureProvider = ref.watch(bannerProvider);
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          // padding: const EdgeInsets.only(top: 2),
          alignment: Alignment.bottomLeft,
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
                          child: CachedNetworkImage(
                            imageUrl: e.imagePath,
                          ),

                          // Image.network(
                          //   e.imagePath!,
                          //   fit: BoxFit.cover,
                          //   width: double.infinity,
                          //   // width: 1000,
                          // ),
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
    );
  }
}
