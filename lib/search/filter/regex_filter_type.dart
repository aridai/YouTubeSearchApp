import 'package:flutter/material.dart';

//  正規表現フィルタの種類
enum RegexFilterType {
  //  なし
  NONE,

  //  ホワイトリスト
  WHITE_LIST,

  //  ブラックリスト
  BLACK_LIST,
}

extension RegexFilterTypeEx on RegexFilterType {
  //  when式の機能を提供する。
  TResult when<TResult>({
    @required TResult none(),
    @required TResult white(),
    @required TResult black(),
    TResult onNull(),
  }) {
    switch (this) {
      case RegexFilterType.NONE:
        return none();

      case RegexFilterType.WHITE_LIST:
        return white();

      case RegexFilterType.BLACK_LIST:
        return black();

      default:
        return onNull();
    }
  }
}
