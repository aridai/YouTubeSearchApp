import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_item.freezed.dart';

//  動画の情報を持つモデル
@freezed
abstract class VideoItem with _$VideoItem {
  factory VideoItem(
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
  ) = _VideoItem;
}
