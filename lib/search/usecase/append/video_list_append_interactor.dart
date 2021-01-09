import 'package:youtube_search_app/search/repository/search_repository.dart';
import 'package:youtube_search_app/search/usecase/append/video_list_append_use_case.dart';

class VideoListAppendInteractor implements VideoListAppendUseCase {
  VideoListAppendInteractor(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<VideoListAppendResponse> execute(
      VideoListAppendRequest request) async {
    final result = await this._searchRepository.searchAdditionally();

    //  取得に成功した場合、フィルタリングして返す。
    if (result is SearchRepositoryResultSuccess) {
      //  TODO: フィルタリング処理

      final videoList = result.searchResultVideoList;
      final hasNextPage = result.hasNextPage;

      return VideoListAppendResponseSuccess(videoList, hasNextPage);
    }

    //  取得に失敗した場合、エラーを返す。
    if (result is SearchRepositoryResultFailure) {
      return VideoListAppendResponseFailure(result.cause);
    }

    throw Exception();
  }
}
