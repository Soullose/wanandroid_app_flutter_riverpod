import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Useful to log state change in our application
/// Read the logs and you'll better understand what's going on under the hood
class StateLogger extends ProviderObserver {
  const StateLogger();

  @override
  Future<void> didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) async {
    if (kDebugMode) {
      print('PROVIDER    : ${provider.name ?? '<NO NAME>'}\n'
          '  Type      : ${provider.runtimeType}\n'
          '  Old value : $previousValue\n'
          '  New value : $newValue');
    }
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }
}
