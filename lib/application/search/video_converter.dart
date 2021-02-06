import 'package:youtube_search_app/model/video.dart';
import 'package:youtube_search_app/model/video_item.dart';

//  Videoのコンバータ
abstract class VideoConverter {
  //  VideoItem型をVideo型に変換する。
  static Video convert(
    VideoItem item,
    DateTime watchedAt,
    bool isBlockedVideo,
    bool isBlockedChannel,
  ) =>
      Video(
        item.videoId,
        item.title,
        item.description,
        item.thumbnailUrl,
        item.uploadedAt,
        item.channelId,
        item.channelTitle,
        watchedAt,
        isBlockedVideo,
        isBlockedChannel,
      );
}
