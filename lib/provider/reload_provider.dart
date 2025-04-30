import 'package:hooks_riverpod/hooks_riverpod.dart';

final xviewProvider =
    StateNotifierProvider<XviewLoader, bool>((ref) => XviewLoader());

class XviewLoader extends StateNotifier<bool> {
  XviewLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}

final xhutviewProvider =
    StateNotifierProvider<HutviewLoader, bool>((ref) => HutviewLoader());

class HutviewLoader extends StateNotifier<bool> {
  HutviewLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}

final xsinglechatProvider =
    StateNotifierProvider<SinglechatLoader, bool>((ref) => SinglechatLoader());

class SinglechatLoader extends StateNotifier<bool> {
  SinglechatLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}

final xgroupchatProvider =
    StateNotifierProvider<GroupchatLoader, bool>((ref) => GroupchatLoader());

class GroupchatLoader extends StateNotifier<bool> {
  GroupchatLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}

final xHutBoxProvider =
    StateNotifierProvider<HutBoxLoader, bool>((ref) => HutBoxLoader());

class HutBoxLoader extends StateNotifier<bool> {
  HutBoxLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}

final xboxProvider =
    StateNotifierProvider<boxLoader, bool>((ref) => boxLoader());

class boxLoader extends StateNotifier<bool> {
  boxLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}

final gamexProvider =
    StateNotifierProvider<GameLoader, bool>((ref) => GameLoader());

class GameLoader extends StateNotifier<bool> {
  GameLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}


final dragxProvider =
    StateNotifierProvider<DragLoader, bool>((ref) => DragLoader());

class DragLoader extends StateNotifier<bool> {
  DragLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}


final tHProvider =
    StateNotifierProvider<THLoader, bool>((ref) => THLoader());

class THLoader extends StateNotifier<bool> {
  THLoader() : super(false);
  void initXviewLoad() {
    state = true;
  }
}
