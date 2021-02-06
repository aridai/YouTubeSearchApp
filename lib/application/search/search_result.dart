import 'package:youtube_search_app/model/video_item.dart';

//  検索結果
abstract class SearchResult {
  //  検索クエリ
  String get query;

  //  検索結果の動画リストのリスト
  List<List<VideoItem>> get videoLists;

  //  次の検索ページが存在するかどうか
  bool get hasNextPage;
}

extension SearchResultEx on SearchResult {
  //  全ページの結果をまとめた動画リストを取得する。
  List<VideoItem> get videos =>
      this.videoLists.expand((innerList) => innerList).toList();
}
