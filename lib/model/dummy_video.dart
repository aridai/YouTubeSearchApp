import 'package:youtube_search_app/model/video.dart';

abstract class DummyVideo {
  static Video create() => Video(
        'VIDEO_ID',
        '動画タイトル',
        '動画説明',
        'https://placehold.jp/26/000000/FFFFFF/320x180.png?text=THUMBNAIL',
        DateTime(2021, 1, 1, 12, 0),
        'CHANNEL_ID',
        'チャンネル名',
        null,
        false,
        false,
      );
}
