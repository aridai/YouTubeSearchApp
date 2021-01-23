import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:youtube_search_app/search/repository/search_repository.dart';
import 'package:youtube_search_app/search/repository/search_result.dart';
import 'package:youtube_search_app/search/repository/youtube_api_service.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._apiService, this._apiKey);

  static const int _maxResults = 10;

  final YouTubeApiService _apiService;
  final String _apiKey;

  //  検索クエリ
  String query = null;

  //  次ページ用トークン
  String nextPageToken = null;

  //  動画リスト
  List<Video> videoList = null;

  @override
  Future<SearchRepositoryResult> search(String keyword) async {
    //  TODO: エンコードの検討
    final query = keyword;

    try {
      final result = await this._apiService.search(
            query: query,
            maxResults: _maxResults,
            key: this._apiKey,
          );

      result.items.map((e) => e.id.videoId);

      final videoList = this._mapVideoList(result.items);
      final hasNextPage = result.nextPageToken != null;

      //  検索情報を残しておく。
      this.nextPageToken = result.nextPageToken;
      this.query = query;
      this.videoList = videoList;

      return SearchRepositoryResult.success(videoList, hasNextPage);
    } on Exception catch (e) {
      return SearchRepositoryResult.failure(this._onError(e));
    }
  }

  @override
  Future<SearchRepositoryResult> searchAdditionally() async {
    try {
      final result = await this._apiService.search(
            query: query,
            pageToken: this.nextPageToken,
            maxResults: _maxResults,
            key: this._apiKey,
          );

      result.items.map((e) => e.id.videoId);

      final additionalVideoList = this._mapVideoList(result.items);
      final concatenatedVideoList = this.videoList + additionalVideoList;
      final hasNextPage = result.nextPageToken != null;

      //  検索情報を残しておく。
      this.nextPageToken = result.nextPageToken;
      this.videoList = concatenatedVideoList;

      return SearchRepositoryResult.success(concatenatedVideoList, hasNextPage);
    } on Exception catch (e) {
      return SearchRepositoryResult.failure(this._onError(e));
    }
  }

  //  エラーが発生したとき。
  //  エラー原因を大まかに切り分ける。
  FetchErrorType _onError(Exception e) {
    if (e is DioError) {
      print('DIOエラー: $e');

      switch (e.type) {
        //  トークンまわりのエラー
        case DioErrorType.RESPONSE:
          return FetchErrorType.TokenError;

        //  タイムアウト系はGoogleのサーバが遅いことはあまり考えられないため、
        //  クライアント側のエラーとみなしてしまう。
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
          return FetchErrorType.ClientError;

        //  オフライン環境で実行するとSocketExceptionが投げられる。
        case DioErrorType.DEFAULT:
          return e.response is SocketException
              ? FetchErrorType.ClientError
              : FetchErrorType.UnknownError;

        default:
          return FetchErrorType.UnknownError;
      }
    } else {
      print('エラー: $e');
      return FetchErrorType.UnknownError;
    }
  }

  //  動画リストに変換する。
  List<Video> _mapVideoList(List<Item> source) => source.map((item) {
        final videoId = item.id.videoId;
        final title = item.snippet.title;
        final description = item.snippet.description;
        final thumbnailUrl = item.snippet.thumbnails.medium.url;
        final uploadedAt = item.snippet.publishedAt;
        final channelId = item.snippet.channelId;
        final channelTitle = item.snippet.channelTitle;

        //  TODO: 追加されたフィールドの対応
        return Video(
          videoId,
          title,
          description,
          thumbnailUrl,
          uploadedAt,
          channelId,
          channelTitle,
          Random().nextBool() ? DateTime.now() : null,
          Random().nextBool(),
          Random().nextBool(),
        );
      }).toList();
}
