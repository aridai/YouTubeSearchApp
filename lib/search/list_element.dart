import 'package:youtube_search_app/video.dart';

//  検索ページのリスト要素
abstract class ListElement {}

//  動画要素
class VideoElement extends ListElement {
  VideoElement(this.model);

  final Video model;
}

//  末尾のProgressIndicator要素
class ProgressIndicatorElement extends ListElement {}
