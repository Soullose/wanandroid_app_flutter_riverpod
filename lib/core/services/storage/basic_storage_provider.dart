import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences_provider.dart';

// class BasicStorage extends StateNotifier {
//   final SharedUtility sharedUtility;
//
//   BasicStorage(this.sharedUtility) : super(null);
// }
part 'basic_storage_provider.g.dart';

@riverpod
class BasicStorage extends _$BasicStorage {
  @override
  void build() {}
}

@riverpod
class IpAddress extends _$IpAddress {
  @override
  String build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final currentValue = preferences.getString('ip') ?? '172.27.96.1';
    listenSelf((prev, curr) {
      preferences.setString('ip', curr);
    });
    return currentValue;
  }
}

@riverpod
class Cookie extends _$Cookie {
  @override
  List<String> build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final cookie = preferences.getStringList('cookie') ?? [];
    listenSelf((prev, curr) {
      preferences.setStringList('cookie', curr);
    });
    return cookie;
  }

  void updateCookie (List<String> cookie) {
    state = cookie;
  }
}

@riverpod
class Token extends _$Token {
  @override
  String build() {
    final preferences = ref.watch(sharedPreferencesProvider);
    final token = preferences.getString('token') ?? '';
    listenSelf((prev, curr) {
      preferences.setString('token', curr);
    });
    return token;
  }

  void updateToken (String token) {
    state = token;
  }
}

final serveAddress = StateProvider<String>(
    (ref) => "http://${ref.watch(ipAddressProvider)}:8080");

final mqttAddress =
    StateProvider<String>((ref) => ref.watch(ipAddressProvider));

// final ipAddressProvider = StateProvider<String>((ref) {
//   final preferences = ref.watch(sharedPreferencesProvider);
//   final currentValue = preferences.getString('ip') ?? '172.27.96.1';
//   ref.listenSelf((prev, curr) {
//     preferences.setString('ip', curr);
//   });
//   return currentValue;
// });

// final cookieProvider = StateProvider<List<String>>((ref) {
//   final preferences = ref.watch(sharedPreferencesProvider);
//   final cookie = preferences.getStringList('cookie') ?? [];
//   ref.listenSelf((previous, next) {
//     preferences.setStringList('cookie', next);
//   });
//   return cookie;
// });

// final tokenProvider = StateProvider<String>((ref) {
//   final preferences = ref.watch(sharedPreferencesProvider);
//   final token = preferences.getString('token') ?? '';
//   ref.listenSelf((previous, next) {
//     preferences.setString('token', next);
//   });
//   return token;
// });
