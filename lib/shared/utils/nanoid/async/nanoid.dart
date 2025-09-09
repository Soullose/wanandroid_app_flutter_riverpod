import 'dart:math';
import 'dart:typed_data';

import '../constants/url_alphabet.dart';

Future<Uint8List> random(int bytes) async {
  var list = List<int>.filled(bytes, 0);
  for (var i = 0; i < bytes; i++) {
    list[i] = Random.secure().nextInt(256);
  }
  return Uint8List.fromList(list);
}

Function customAlphabetAsync(String alphabet, [int defaultSize = 21]) {
  final mask = (1 << (31 - urlAlphabet.length.toUnsigned(32).bitLength)) - 1;
  final step = ((1.6 * mask * defaultSize) / alphabet.length).ceil();
  tick(String id, [int size = 21]) async {
    final bytes = await random(step);
    for (var i = 0; i < bytes.length; i++) {
      id += alphabet[bytes[i] & mask];
      if (id.length == size) return id;
    }
    return tick(id, size);
  }

  return (int size) => tick('', size);
}

Future<String> nanoidAsync([int size = 21]) async {
  final bytes = await random(size);
  var id = '';
  for (var i = 0; i < bytes.length; i++) {
    id += urlAlphabet[bytes[i] & 63];
  }
  return id;
}
