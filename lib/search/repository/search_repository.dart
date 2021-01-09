import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

//  検索処理のリポジトリ
abstract class SearchRepository {
  //  検索を行う。
  Future<SearchRepositoryResult> search(String keyword);

  //  前回の結果から追加検索を行う。
  Future<SearchRepositoryResult> searchAdditionally();
}

//  検索結果
abstract class SearchRepositoryResult {}

//  成功
class SearchRepositoryResultSuccess extends SearchRepositoryResult {
  SearchRepositoryResultSuccess(this.searchResultVideoList, this.hasNextPage);

  //  検索結果の動画リスト
  //  (フィルタ未適用)
  //  (追加取得分も前回取得分も含めたリスト)
  final List<Video> searchResultVideoList;

  //  検索結果に次のページが存在するかどうか。
  final bool hasNextPage;
}

//  失敗
class SearchRepositoryResultFailure extends SearchRepositoryResult {
  SearchRepositoryResultFailure(this.cause);

  //  エラー原因
  final FetchErrorType cause;
}
