import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wanandroid_app_flutter_riverpod/modules/home/provider/banner_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerFutureProvider = ref.watch(bannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('首页'),),
      body: RepaintBoundary(
        child: Column(
          children: [
            bannerFutureProvider.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (data) {
                return CarouselSlider(
                  items: data
                      .map((e) => Center(
                    child: Image.network(
                      e.imagePath!,
                      fit: BoxFit.cover,
                      // width: 1000,
                    ),
                  ))
                      .toList(),
                  options: CarouselOptions(height: 190.0),
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 88,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.blue[(index % 5) * 100],
                    height: 20,
                    alignment: Alignment.center,
                    child: Text('$index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
