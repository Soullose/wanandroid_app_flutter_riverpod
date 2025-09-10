// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'dart:async';
import 'dart:developer';

import 'bootstrap.dart';

void main() {
  runZonedGuarded(
    () async {
      await bootstrap();
    },
    (error, stack) {
      return log(error.toString(), stackTrace: stack);
    },
  );
}
