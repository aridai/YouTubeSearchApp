import 'package:youtube_search_app/data/api/search_result.dart';
import 'package:youtube_search_app/model/video_item.dart';

//  VideoItemのコンバータ
abstract class VideoItemConverter {
  //  YouTubeの検索APIのレスポンスのItem型をVideoItem型に変換する。
  static VideoItem convert(Item item) {
    final videoId = item.id.videoId;
    final title = item.snippet.title;
    final description = item.snippet.description;
    final thumbnailUrl = item.snippet.thumbnails.medium.url;
    final uploadedAt = item.snippet.publishedAt;
    final channelId = item.snippet.channelId;
    final channelTitle = item.snippet.channelTitle;

    return VideoItem(
      videoId,
      title,
      description,
      thumbnailUrl,
      uploadedAt,
      channelId,
      channelTitle,
    );
  }
}
