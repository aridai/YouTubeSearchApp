//  動画のモデル
class Video {
  Video(
    this.videoId,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.uploadedAt,
    this.channelId,
    this.channelTitle,
  );

  //  動画ID
  final String videoId;

  //  動画タイトル
  final String title;

  //  動画説明
  final String description;

  //  動画サムネイルのURL
  final String thumbnailUrl;

  //  動画の投稿日時
  final DateTime uploadedAt;

  //  この動画を投稿したチャンネルID
  final String channelId;

  //  この動画を投稿したチャンネル名
  final String channelTitle;

  //  動画のURL
  String get videoUrl => 'https://www.youtube.com/watch?v=${this.videoId}';

  @override
  String toString() => 'Video('
      'videoId=$videoId, '
      'title=$title, '
      'description=$description, '
      'thumbnailUrl=$thumbnailUrl, '
      'uploadedAt=$uploadedAt, '
      'channelId=$channelId, '
      'channelTitle=$channelTitle'
      ')';
}
