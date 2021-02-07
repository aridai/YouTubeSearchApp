import 'package:youtube_search_app/model/video.dart';

//  視聴履歴を保存する。
abstract class WatchHistorySaveUseCase {
  Future<WatchHistorySaveResponse> execute(WatchHistorySaveRequest request);
}

//  リクエスト
class WatchHistorySaveRequest {
  WatchHistorySaveRequest(this.video);

  //  視聴履歴の保存対象の動画
  final Video video;
}

//  レスポンス
class WatchHistorySaveResponse {}
