import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

//  動画リストの追加取得を行う。
abstract class VideoListAppendUseCase {
  Future<VideoListAppendResponse> execute(VideoListAppendRequest request);
}

//  リクエスト
class VideoListAppendRequest {}

//  レスポンス
abstract class VideoListAppendResponse {}

//  成功
class VideoListAppendResponseSuccess extends VideoListAppendResponse {
  VideoListAppendResponseSuccess(this.videoList, this.hasNextPage);

  //  結果の動画リスト
  final List<Video> videoList;

  //  次のページが存在するかどうか
  final bool hasNextPage;
}

//  失敗
class VideoListAppendResponseFailure extends VideoListAppendResponse {
  VideoListAppendResponseFailure(this.cause);

  //  エラーの原因
  final FetchErrorType cause;
}
