import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/result_data.dart';
import 'package:wanandroid_app_flutter_riverpod/common/utils/log_utils.dart';

import '../../../common/constants/api_address.dart';
import '../../../common/net/http_client.dart';
import '../../../model/article/banner/banner.dart';

final bannerProvider = FutureProvider<List<Banner>>((ref) async {
  final httpManager = ref.read(httpManagerProvider.notifier);
  ResultData? response = await httpManager.netFetch(ApiAddress.bannerUrl);
  response?.getData().map((e) => LogUtils.d('-------$e'));
  return bannerFromJson(jsonEncode(response?.getData()));
});


// class Banner