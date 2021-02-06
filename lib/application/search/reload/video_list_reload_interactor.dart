import 'package:youtube_search_app/application/search/reload/video_list_reload_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/application/search/video_converter.dart';

class VideoListReloadInteractor implements VideoListReloadUseCase {
  VideoListReloadInteractor(this._repository);

  final SearchRepository _repository;

  @override
  Future<VideoListReloadResponse> execute(
      VideoListReloadRequest request) async {
    final result = this._repository.getSearchResult();
    //  TODO: 視聴履歴の検索処理
    //  TODO: ブロックデータの取得処理
    //  TODO: フィルタリング処理

    final videoList = result.videos
        .map((item) => VideoConverter.convert(item, null, false, false))
        .toList(growable: false);

    //  TODO: 検索履歴の更新

    return VideoListReloadResponse(videoList, result.hasNextPage);
  }
}
