import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.freezed.dart';

//  動画のモデル
@freezed
abstract class Video with _$Video {
  factory Video(
    //  動画ID
    String videoId,

    //  動画タイトル
    String title,

    //  動画説明
    String description,

    //  動画サムネイルのURL
    String thumbnailUrl,

    //  動画の投稿日時
    DateTime uploadedAt,

    //  この動画を投稿したチャンネルID
    String channelId,

    //  この動画を投稿したチャンネル名
    String channelTitle,

    //  視聴日時
    @nullable DateTime watchedAt,

    //  ブロックされている動画かどうか
    bool isBlockedVideo,

    //  ブロックされているチャンネルの動画かどうか
    bool isBlockedChannel,
  ) = _Video;
}
