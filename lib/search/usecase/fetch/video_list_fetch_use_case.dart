import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

//  動画リストを取得する。
abstract class VideoListFetchUseCase {
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request);
}

//  リクエスト
class VideoListFetchRequest {
  VideoListFetchRequest(this.keyword, this.options);

  //  キーワード
  final String keyword;

  //  検索オプション
  //  (仮)
  final Object options;
}

//  レスポンス
abstract class VideoListFetchResponse {}

//  成功
class VideoListFetchResponseSuccess extends VideoListFetchResponse {
  VideoListFetchResponseSuccess(this.videoList, this.hasNextPage);

  //  結果の動画リスト
  final List<Video> videoList;

  //  次のページが存在するかどうか
  final bool hasNextPage;
}

//  失敗
class VideoListFetchResponseFailure extends VideoListFetchResponse {
  VideoListFetchResponseFailure(this.cause);

  //  エラーの原因
  final FetchErrorType cause;
}
