import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

/// 検索結果
/// https://developers.google.com/youtube/v3/docs/search/list
@JsonSerializable()
class SearchResult {
  SearchResult(
    this.kind,
    this.etag,
    this.nextPageToken,
    this.prevPageToken,
    this.regionCode,
    this.pageInfo,
    this.items,
  );

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  /// APIのリソースタイプ
  /// 検索の場合は「youtube#searchListResponse」となる。
  final String kind;

  /// このリソースのEtag
  final String etag;

  /// 次のページの検索用トークン
  /// (nullとなる可能性がある。)
  final String nextPageToken;

  /// 前のページの検索用トークン
  /// (nullとなる可能性がある。)
  final String prevPageToken;

  /// リージョンコード
  /// 日本の場合は「JP」となる。
  final String regionCode;

  /// 検索のページング情報
  final PageInfo pageInfo;

  /// 検索結果のリスト
  final List<Item> items;

  @override
  String toString() => 'SearchResult('
      'kind=$kind, '
      'etag=$etag, '
      'nextPageToken=$nextPageToken, '
      'prevPageToken=$prevPageToken, '
      'regionCode=$regionCode, '
      'pageInfo=$pageInfo, '
      'items=$items'
      ')';
}

/// 検索のページング情報
@JsonSerializable()
class PageInfo {
  PageInfo(
    this.totalResults,
    this.resultsPerPage,
  );

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);

  /// 合計の検索結果の数
  final int totalResults;

  /// APIレスポンスに含まれる結果の数
  final int resultsPerPage;

  @override
  String toString() =>
      'PageInfo(totalResults=$totalResults, resultsPerPage=$resultsPerPage)';
}

/// 検索結果の要素
/// https://developers.google.com/youtube/v3/docs/search
@JsonSerializable()
class Item {
  Item(
    this.kind,
    this.etag,
    this.id,
    this.snippet,
  );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  /// この要素のリソースタイプ
  /// 検索の場合は「youtube#searchResult」となる。
  final String kind;

  /// この要素のEtag
  final String etag;

  /// この要素の種類ごとのID
  final Id id;

  /// この要素の詳細
  final Snippet snippet;

  @override
  String toString() => 'Item(kind=$kind, etag=$etag, id=$id, snippet=$snippet)';
}

/// 検索結果の要素のID
@JsonSerializable()
class Id {
  Id(
    this.kind,
    this.videoId,
    this.channelId,
    this.playlistId,
  );

  factory Id.fromJson(Map<String, dynamic> json) => _$IdFromJson(json);

  /// この要素の種類
  /// 動画の場合は「youtube#video」となる。
  /// チャンネルの場合は「youtube#channel」となる。
  /// プレイリストの場合は「youtube#playlist」となる。
  final String kind;

  /// この動画のID
  /// (この要素が動画でない場合はnullとなる。)
  final String videoId;

  /// このチャンネルのID
  /// (この要素がチャンネルでない場合はnullとなる。)
  final String channelId;

  /// このプレイリストのID
  /// (この要素がプレイリストでない場合はnullとなる。)
  final String playlistId;

  @override
  String toString() => 'Id('
      'kind=$kind, '
      'videoId=$videoId, '
      'channelId=$channelId, '
      'playlistId=$playlistId'
      ')';
}

/// 検索結果項目の詳細
@JsonSerializable()
class Snippet {
  Snippet(
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
  );

  factory Snippet.fromJson(Map<String, dynamic> json) =>
      _$SnippetFromJson(json);

  /// 作成日時
  final DateTime publishedAt;

  /// チャネルID
  final String channelId;

  /// タイトル
  final String title;

  /// 説明
  final String description;

  /// サムネイル画像
  final Thumbnails thumbnails;

  /// チャンネルのタイトル
  final String channelTitle;

  @override
  String toString() => 'Snippet('
      'publishedAt=$publishedAt, '
      'channelId=$channelId, '
      'title=$title, '
      'description=$description, '
      'thumbnails=$thumbnails, '
      'channelTitle=$channelTitle)';
}

/// サムネイル画像のセット
@JsonSerializable()
class Thumbnails {
  Thumbnails(
    this.defaultThumb,
    this.medium,
    this.high,
  );

  factory Thumbnails.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailsFromJson(json);

  /// デフォルトサイズのサムネイル画像
  @JsonKey(name: 'default')
  final Thumbnail defaultThumb;

  /// 中解像度のサムネイル画像
  final Thumbnail medium;

  /// 高解像度のサムネイル画像
  final Thumbnail high;

  @override
  String toString() =>
      'Thumbnails(defaultThumb=$defaultThumb, medium=$medium, high=$high)';
}

/// サムネイル画像
@JsonSerializable()
class Thumbnail {
  Thumbnail(
    this.url,
    this.width,
    this.height,
  );

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  /// サムネイル画像のURL
  final String url;

  /// サムネイル画像の横幅
  final int width;

  /// サムネイル画像の高さ
  final int height;

  @override
  String toString() => 'Thumbnail(url=$url, width=$width, height=$height)';
}
