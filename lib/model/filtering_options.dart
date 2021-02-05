import 'package:freezed_annotation/freezed_annotation.dart';

part 'filtering_options.freezed.dart';

//  フィルタリングオプション
@freezed
abstract class FilteringOptions with _$FilteringOptions {
  factory FilteringOptions(
    //  視聴済み動画を含めるかどうか
    bool includesWatchedVideos,

    //  ブロックした動画を含めるかどうか
    bool includesBlockedVideos,

    //  ブロックしたチャンネルの動画を含めるかどうか
    bool includesBlockedChannels,

    //  正規表現フィルタ
    RegexFiltering regexFiltering,
  ) = _FilteringOptions;
}

//  正規表現フィルタ
@freezed
abstract class RegexFiltering with _$RegexFiltering {
  //  フィルタリングなし
  const factory RegexFiltering.none() = None;

  //  ホワイトリスト方式
  const factory RegexFiltering.white(String pattern) = White;

  //  ブラックリスト方式
  const factory RegexFiltering.black(String pattern) = Black;
}
