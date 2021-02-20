import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/model/video.dart';

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

extension FilteringOptionsExtension on FilteringOptions {
  //  対象の動画をフィルタリングによって含めるべきかどうかを判定する。
  bool shouldInclude(Video video) {
    //  視聴済み動画のフィルタリングをする。
    if (!this.includesWatchedVideos && video.hasBeenWatched) return false;

    //  ブロック済み動画のフィルタリングをする。
    if (!this.includesBlockedVideos && video.isBlockedVideo) return false;

    //  ブロック済みチャンネルのフィルタリングをする。
    if (!this.includesBlockedChannels && video.isBlockedChannel) return false;

    //  最後に正規表現フィルタリングをする。
    return this.regexFiltering.when(
          //  正規表現フィルタリングなしの場合、問答無用で含めるべきと判定する。
          none: () => true,

          //  ホワイトリスト方式の場合、マッチしたら含めるべきと判定する。
          white: (pattern) => RegExp(pattern).hasMatch(video.title),

          //  ブラックリスト方式の場合、マッチしたら含めるべきでないと判定する。
          black: (pattern) => !RegExp(pattern).hasMatch(video.title),
        );
  }
}
