import 'package:youtube_search_app/model/filtering_options.dart';

abstract class FilteringOptionsRepository {
  //  FilteringOptionsを取得する。
  FilteringOptions getOptions();

  //  FilteringOptionsを保存する。
  Future<void> saveOptions(FilteringOptions options);
}
