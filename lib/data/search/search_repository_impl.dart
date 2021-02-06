import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/data/api/youtube_api_service.dart';
import 'package:youtube_search_app/data/search/fetch_error_type_converter.dart';
import 'package:youtube_search_app/data/search/video_item_converter.dart';
import 'package:youtube_search_app/data/search/youtube_search_result.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._apiService, this._apiKey);

  //  1回の検索に含める件数
  static const int _maxResults = 10;

  final YouTubeApiService _apiService;
  final String _apiKey;

  //  直近の検索結果
  YouTubeSearchResult _result = null;

  //  直近の検索結果を返す。
  //  nullの場合もそのまま返す。
  @override
  SearchResult getSearchResult() => this._result?.asSearchResult();

  //  新規に検索を掛ける。
  @override
  Future<SearchRepositoryResult> search(String keyword) async {
    //  TODO: エンコードの検討
    final query = keyword;

    try {
      final apiResult = await this._apiService.search(
            query: query,
            maxResults: _maxResults,
            key: this._apiKey,
          );

      //  検索結果を変換する。
      final videoList = apiResult.items
          .map((item) => VideoItemConverter.convert(item))
          .toList(growable: false);
      final result =
          YouTubeSearchResult(query, [videoList], apiResult.nextPageToken);

      //  検索情報を保持しておく。
      this._result = result;

      return SearchRepositoryResult.success(result.asSearchResult());
    } on Exception catch (e) {
      final errorType = FetchErrorTypeConverter.convert(e);

      return SearchRepositoryResult.failure(errorType);
    }
  }

  //  追加で検索を掛ける。
  @override
  Future<SearchRepositoryResult> searchAdditionally() async {
    //  このメソッドは前回の検索結果が絶対に存在するときに呼ばれるはず。
    final prevResult = this._result;
    if (prevResult == null) throw StateError('前回の検索結果が存在しない状態で追加取得を試行しました。');

    try {
      final apiResult = await this._apiService.search(
            query: prevResult.query,
            pageToken: prevResult.nextPageToken,
            maxResults: _maxResults,
            key: this._apiKey,
          );

      //  追加で取得した動画リストを既存の動画リストのリストの末尾に追加する。
      final additionalVideoList = apiResult.items
          .map((item) => VideoItemConverter.convert(item))
          .toList(growable: false);
      final updatedVideoLists = prevResult.videoLists + [additionalVideoList];

      //  更新した検索結果データを生成し、保持しておく。
      final updatedResult = YouTubeSearchResult(
        prevResult.query,
        updatedVideoLists,
        apiResult.nextPageToken,
      );
      this._result = updatedResult;

      return SearchRepositoryResult.success(updatedResult.asSearchResult());
    } on Exception catch (e) {
      final errorType = FetchErrorTypeConverter.convert(e);

      return SearchRepositoryResult.failure(errorType);
    }
  }
}
