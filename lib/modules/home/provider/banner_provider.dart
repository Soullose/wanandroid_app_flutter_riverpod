import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../common/constants/api_address.dart';
import '../../../common/net/http_client.dart';
import '../../../model/article/banner/banner.dart';

final bannerProvider = FutureProvider<List<Banner>>((ref) async {
  final httpManager = ref.read(httpManagerProvider.notifier);
  dynamic response = await httpManager.netFetch(ApiAddress.bannerUrl);
  print(jsonEncode(response.data['data']));
  return bannerFromJson(jsonEncode(response.data['data']));
});
