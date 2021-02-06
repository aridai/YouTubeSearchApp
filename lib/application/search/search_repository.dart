import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/application/fetch_error_type.dart';
import 'package:youtube_search_app/application/search/search_result.dart';

part 'search_repository.freezed.dart';

//  検索処理のリポジトリ
abstract class SearchRepository {
  //  直近の検索結果を取得する。
  //  (存在しない場合はnullを返す。)
  SearchResult getSearchResult();

  //  検索を行う。
  Future<SearchRepositoryResult> search(String keyword);

  //  前回の結果から追加検索を行う。
  Future<SearchRepositoryResult> searchAdditionally();
}

//  検索結果
@freezed
abstract class SearchRepositoryResult with _$SearchRepositoryResult {
  //  成功
  const factory SearchRepositoryResult.success(SearchResult result) = Success;

  //  失敗
  const factory SearchRepositoryResult.failure(FetchErrorType cause) = Failure;
}
