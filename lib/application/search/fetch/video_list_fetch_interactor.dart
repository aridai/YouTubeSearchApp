import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/application/search/video_converter.dart';

class VideoListFetchInteractor implements VideoListFetchUseCase {
  VideoListFetchInteractor(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request) async {
    final result = await this._searchRepository.search(request.keyword);

    return result.when(
      //  取得に成功した場合、オプションに応じてフィルタリングする。
      success: (result) {
        //  TODO: 視聴履歴の検索処理
        //  TODO: ブロックデータの取得処理
        //  TODO: フィルタリング処理

        final videoList = result.videos
            .map((item) => VideoConverter.convert(item, null, false, false))
            .toList(growable: false);

        return VideoListFetchResponse.success(videoList, result.hasNextPage);
      },

      //  取得に失敗した場合、エラーとして返す。
      failure: (cause) => VideoListFetchResponse.failure(cause),
    );
  }
}
