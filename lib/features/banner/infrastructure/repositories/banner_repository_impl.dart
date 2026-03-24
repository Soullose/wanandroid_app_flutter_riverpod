import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_address.dart';
import '../../../../core/net/http_client.dart';
import '../../../../core/net/result_data.dart';
import '../../../../core/net/result_data_extension.dart';
import '../../domain/entities/banner.dart';
import '../../domain/repositories/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final Ref _ref;

  BannerRepositoryImpl(this._ref);

  @override
  Future<List<Banner>> getBanner() async {
    final httpManager = _ref.read(httpManagerProvider.notifier);
    ResultData? response = await httpManager.netFetch(ApiAddress.bannerUrl);

    // 使用扩展方法解析列表数据
    final bannerList = response?.parseList<Banner>(
      (json) => Banner.fromJson(json),
    );

    return bannerList ?? [];
  }
}
