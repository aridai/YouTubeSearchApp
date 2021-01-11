import 'package:youtube_search_app/search/repository/search_repository.dart';
import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';

class VideoListFetchInteractor implements VideoListFetchUseCase {
  VideoListFetchInteractor(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request) async {
    final result = await this._searchRepository.search(request.keyword);

    //  取得に成功した場合、オプションに応じてフィルタリングする。
    if (result is SearchRepositoryResultSuccess) {
      //  TODO: フィルタリング処理

      final videoList = result.searchResultVideoList;
      final hasNextPage = result.hasNextPage;

      return VideoListFetchResponse.success(videoList, hasNextPage);
    }

    //  取得に失敗した場合、エラーとして返す。
    if (result is SearchRepositoryResultFailure) {
      return VideoListFetchResponse.failure(result.cause);
    }

    throw Exception();
  }
}
