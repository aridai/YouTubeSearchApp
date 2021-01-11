import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

part 'video_list_append_use_case.freezed.dart';

//  動画リストの追加取得を行う。
abstract class VideoListAppendUseCase {
  Future<VideoListAppendResponse> execute(VideoListAppendRequest request);
}

//  リクエスト
class VideoListAppendRequest {}

//  レスポンス
@freezed
abstract class VideoListAppendResponse with _$VideoListAppendResponse {
  //  成功
  const factory VideoListAppendResponse.success(
    //  結果の動画リスト
    List<Video> videoList,

    //  次のページが存在するかどうか
    bool hasNextPage,
  ) = Success;

  //  失敗
  const factory VideoListAppendResponse.failure(FetchErrorType cause) = Failure;
}
