import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wanandroid_app_flutter_riverpod/common/constants/api_address.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/http_client.dart';
import 'package:wanandroid_app_flutter_riverpod/common/net/result_data.dart';
// import 'package:wanandroid_app_flutter_riverpod/common/utils/log_utils.dart';
import 'package:wanandroid_app_flutter_riverpod/model/models.dart';

final bannerProvider = FutureProvider<List<Banner>>((ref) async {
  final httpManager = ref.read(httpManagerProvider.notifier);
  ResultData? response = await httpManager.netFetch(ApiAddress.bannerUrl);
  // if (kDebugMode) {
  //   print('response:${response?.data}');
  // }
  // response?.getData().map((e) => LogUtils.d('-------$e'));

  /// ResultData<Banner>.fromJson(e, (json) => Banner.fromJson(json))
  return bannerFromJson(jsonEncode(response?.getData()));
});

// class Banner
