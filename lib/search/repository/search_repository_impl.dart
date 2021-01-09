import 'package:youtube_search_app/search/repository/search_repository.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';

class SearchRepositoryImpl implements SearchRepository {
  //  直近の検索キーワード
  String recentKeyword = null;

  //  直近のYouTube検索APIの次ページ用トークン
  String recentNextPageToken = null;

  @override
  Future<SearchRepositoryResult> search(String keyword) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return SearchRepositoryResultFailure(FetchErrorType.UnknownError);
  }

  @override
  Future<SearchRepositoryResult> searchAdditionally() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return SearchRepositoryResultFailure(FetchErrorType.UnknownError);
  }
}
