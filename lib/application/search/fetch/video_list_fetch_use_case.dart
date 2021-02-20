import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/application/fetch_error_type.dart';
import 'package:youtube_search_app/model/filtering_options.dart';
import 'package:youtube_search_app/model/video.dart';

part 'video_list_fetch_use_case.freezed.dart';

//  動画リストを取得するユースケース
abstract class VideoListFetchUseCase {
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request);
}

//  リクエスト
class VideoListFetchRequest {
  VideoListFetchRequest(this.keyword, this.options);

  //  キーワード
  final String keyword;

  //  フィルタオプション
  final FilteringOptions options;
}

//  レスポンス
@freezed
abstract class VideoListFetchResponse with _$VideoListFetchResponse {
  //  成功
  const factory VideoListFetchResponse.success(
    //  結果の動画リスト
    List<Video> videoList,

    //  次のページが存在するかどうか
    bool hasNextPage,
  ) = Success;

  //  失敗
  const factory VideoListFetchResponse.failure(FetchErrorType cause) = Failure;
}
