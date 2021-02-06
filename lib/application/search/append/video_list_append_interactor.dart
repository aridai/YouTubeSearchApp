import 'package:youtube_search_app/application/search/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/application/search/video_converter.dart';

class VideoListAppendInteractor implements VideoListAppendUseCase {
  VideoListAppendInteractor(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<VideoListAppendResponse> execute(
      VideoListAppendRequest request) async {
    final result = await this._searchRepository.searchAdditionally();

    return result.when(
      //  取得に成功した場合、フィルタリングして返す。
      success: (result) {
        //  TODO: 視聴履歴の検索処理
        //  TODO: ブロックデータの取得処理
        //  TODO: フィルタリング処理

        final videoList = result.videos
            .map((item) => VideoConverter.convert(item, null, false, false))
            .toList(growable: false);

        return VideoListAppendResponse.success(videoList, result.hasNextPage);
      },

      //  取得に失敗した場合、エラーを返す。
      failure: (cause) => VideoListAppendResponse.failure(cause),
    );
  }
}
