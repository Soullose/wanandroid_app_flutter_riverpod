import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());
//
// final sharedUtilityProvider = Provider<SharedUtility>((ref) {
//   final sharedPrefs = ref.watch(sharedPreferencesProvider);
//   return SharedUtility(prefs: sharedPrefs);
// });
//
// class SharedUtility {
//   final SharedPreferences prefs;
//
//   SharedUtility({required this.prefs});
//
//   Future<bool> setString(String key, String value) async {
//     return await prefs.setString(key, value);
//   }
//
//   Future<bool> setInt(String key, int value) async {
//     return await prefs.setInt(key, value);
//   }
//
//   Future<bool> setBool(String key, bool value) async {
//     return await prefs.setBool(key, value);
//   }
//
//   Future<bool> setList(String key, List<String> value) async {
//     return await prefs.setStringList(key, value);
//   }
//
//   String getString(String key) {
//     return prefs.getString(key) ?? '';
//   }
//
//   bool getBool(String key) {
//     return prefs.getBool(key) ?? false;
//   }
//
//   List<String> getList(String key) {
//     return prefs.getStringList(key) ?? [];
//   }
//
//   Future<bool> remove(String key) async {
//     return await prefs.remove(key);
//   }
// }
