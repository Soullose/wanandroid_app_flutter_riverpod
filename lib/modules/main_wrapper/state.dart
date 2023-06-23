import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainWrapper extends StateNotifier<int> {
  MainWrapper() : super(0);

  // set
  set _index(int value) => state = value;

  //get
  get current => state;

  //bottomNavigationBar选择哪个页面时将pageNumber赋值给状态管理器
  void select(int value) => _index = value;
}

// riverpod中MainWrapper的StateNotifierProvider
final mainWrapperProvider =
    StateNotifierProvider<MainWrapper, int>((ref) => MainWrapper());
