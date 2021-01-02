import 'package:get_it/get_it.dart';

//  DIコンテナのラッパ
class Dependency {
  //  依存関係の設定を行う。
  static void setup() {}

  //  依存関係の解決を行う。
  static T resolve<T>({String name}) => GetIt.I.get(instanceName: name);
}
