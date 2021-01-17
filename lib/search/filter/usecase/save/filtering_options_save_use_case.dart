import 'package:youtube_search_app/search/filter/filtering_options.dart';

//  フィルタリングオプションを保存するユースケース
abstract class FilteringOptionsSaveUseCase {
  FilteringOptionsSaveResponse execute(FilteringOptionsSaveRequest request);
}

//  リクエスト
class FilteringOptionsSaveRequest {
  FilteringOptionsSaveRequest(this.options);

  final FilteringOptions options;
}

//  レスポンス
class FilteringOptionsSaveResponse {}
