import 'package:test/test.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/ui/search/list/list_element.dart';

//  VideoListFetchUseCaseのリクエストに渡した検索キーワードのMatcherを生成する。
Matcher searchKeywordEquals(String keyword) =>
    predicate<VideoListFetchRequest>((r) => r.keyword == keyword);

//  List<ListElement>に対するMatcherを生成する。
typedef ListPredicate = bool Function(List<ListElement> list);

Matcher listPredicate(ListPredicate listPredicate) => predicate(listPredicate);
