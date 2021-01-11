import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

part 'search_repository.freezed.dart';

//  検索処理のリポジトリ
abstract class SearchRepository {
  //  検索を行う。
  Future<SearchRepositoryResult> search(String keyword);

  //  前回の結果から追加検索を行う。
  Future<SearchRepositoryResult> searchAdditionally();
}

//  検索結果
@freezed
abstract class SearchRepositoryResult with _$SearchRepositoryResult {
  //  成功
  const factory SearchRepositoryResult.success(
    //  検索結果の動画リスト
    //  (追加取得分も前回取得分も含めた、フィルタ未適用のリスト)
    List<Video> searchResultVideoList,

    //  検索結果に次のページが存在するかどうか。
    bool hasNextPage,
  ) = Success;

  //  失敗
  const factory SearchRepositoryResult.failure(FetchErrorType cause) = Failure;
}
