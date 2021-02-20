//  動画リストをリロードするユースケース
import 'package:youtube_search_app/model/filtering_options.dart';
import 'package:youtube_search_app/model/video.dart';

//  動画リストをリロードするユースケース
abstract class VideoListReloadUseCase {
  //  現時点で取得済みの動画リストをリロードする。
  //  (フィルタオプションが更新されたときに呼ばれる。)
  Future<VideoListReloadResponse> execute(VideoListReloadRequest request);
}

//  リクエスト
class VideoListReloadRequest {
  VideoListReloadRequest(this.options);

  //  フィルタリングオプション
  final FilteringOptions options;
}

//  レスポンス
class VideoListReloadResponse {
  VideoListReloadResponse(this.videoList, this.hasNextPage);

  //  結果の動画リスト
  final List<Video> videoList;

  //  次のページが存在するかどうか
  final bool hasNextPage;
}
