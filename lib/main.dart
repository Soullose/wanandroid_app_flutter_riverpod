// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'bootstrap.dart';

Future<void> main() async {
  // unawaited(
  //   bootstrap(),
  // );
  await bootstrap();
  // runZonedGuarded(
  //   () async {
  //     await bootstrap();
  //   },
  //   (error, stack) {
  //     return log(error.toString(), stackTrace: stack);
  //   },
  // );
}
