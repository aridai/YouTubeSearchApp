import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';

class VideoListFetchInteractor implements VideoListFetchUseCase {
  VideoListFetchInteractor(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request) async {
    final result = await this._searchRepository.search(request.keyword);

    return result.when(
      //  取得に成功した場合、オプションに応じてフィルタリングする。
      success: (list, hasNext) {
        //  TODO: フィルタリング処理
        return VideoListFetchResponse.success(list, hasNext);
      },

      //  取得に失敗した場合、エラーとして返す。
      failure: (cause) => VideoListFetchResponse.failure(cause),
    );
  }
}
