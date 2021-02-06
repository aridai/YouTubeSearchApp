//  動画リストをリロードするユースケース
import 'package:youtube_search_app/model/video.dart';

abstract class VideoListReloadUseCase {
  //  動画リストをリロードする。
  //  (フィルタオプションが更新されたときに呼ばれる。)
  Future<VideoListReloadResponse> execute(VideoListReloadRequest request);
}

//  リクエスト
class VideoListReloadRequest {}

//  レスポンス
class VideoListReloadResponse {
  VideoListReloadResponse(this.videoList, this.hasNextPage);

  //  結果の動画リスト
  final List<Video> videoList;

  //  次のページが存在するかどうか
  final bool hasNextPage;
}
