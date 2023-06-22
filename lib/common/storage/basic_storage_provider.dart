import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'shared_preferences_provider.dart';

// class BasicStorage extends StateNotifier {
//   final SharedUtility sharedUtility;
//
//   BasicStorage(this.sharedUtility) : super(null);
// }

final ipAddressProvider = StateProvider<String>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final currentValue = preferences.getString('ip') ?? '172.30.160.1';
  ref.listenSelf((prev, curr) {
    preferences.setString('ip', curr);
  });
  return currentValue;
});

final serveAddress = StateProvider<String>(
    (ref) => "http://${ref.watch(ipAddressProvider)}:8080");

final mqttAddress =
    StateProvider<String>((ref) => ref.watch(ipAddressProvider));

final cookieProvider = StateProvider<List<String>>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final cookie = preferences.getStringList('cookie') ?? [];
  ref.listenSelf((previous, next) {
    preferences.setStringList('cookie', next);
  });
  return cookie;
});

final tokenProvider = StateProvider<String>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final token = preferences.getString('token') ?? '';
  ref.listenSelf((previous, next) {
    preferences.setString('token', next);
  });
  return token;
});
