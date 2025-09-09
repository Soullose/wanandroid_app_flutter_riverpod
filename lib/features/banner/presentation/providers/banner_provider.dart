import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wanandroid_app_flutter_riverpod/features/banner/domain/entities/banner.dart';

import '../../infrastructure/repositories/banner_repository_impl.dart';

part 'banner_provider.g.dart';

@riverpod
Future<List<Banner>> banner(Ref ref) async {
  return await BannerRepositoryImpl(ref).getBanner();
}
