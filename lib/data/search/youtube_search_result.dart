import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/model/video_item.dart';

part 'youtube_search_result.freezed.dart';

//  YouTubeの検索結果
//  (アプリケーション層のSearchResultの派生)
@freezed
abstract class YouTubeSearchResult implements _$YouTubeSearchResult {
  factory YouTubeSearchResult(
    String query,
    List<List<VideoItem>> videoLists,
    @nullable String nextPageToken,
  ) =>
      YouTubeSearchResult.create(
        query,
        videoLists,
        nextPageToken,
        nextPageToken != null,
      );

  @Implements(SearchResult)
  const factory YouTubeSearchResult.create(
    String query,
    List<List<VideoItem>> videoLists,
    @nullable String nextPageToken,
    bool hasNextPage,
  ) = _YouTubeSearchResult;

  const YouTubeSearchResult._();

  SearchResult asSearchResult() => this as SearchResult;
}
