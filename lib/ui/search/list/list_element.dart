import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/model/video.dart';

part 'list_element.freezed.dart';

//  検索ページのリスト要素
@freezed
abstract class ListElement with _$ListElement {
  //  動画要素
  const factory ListElement.video(Video video) = VideoElement;

  //  ProgressIndicator要素
  const factory ListElement.indicator() = ProgressIndicatorElement;
}
