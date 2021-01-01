import 'package:youtube_search_app/video.dart';

//  ダミーの動画のモデル
class DummyVideo extends Video {
  DummyVideo()
      : super(
          'VIDEO_ID',
          '動画タイトル',
          '動画説明',
          'https://placehold.jp/26/000000/FFFFFF/320x180.png?text=THUMBNAIL',
          DateTime(2021, 1, 1, 12, 0),
          'CHANNEL_ID',
          'チャンネル名',
        );
}
