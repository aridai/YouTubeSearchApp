import 'package:youtube_search_app/model/filtering_options.dart';

//  フィルタリングオプションを取得するユースケース
abstract class FilteringOptionsFetchUseCase {
  FilteringOptionsFetchResponse execute(FilteringOptionsFetchRequest request);
}

//  リクエスト
class FilteringOptionsFetchRequest {}

//  レスポンス
class FilteringOptionsFetchResponse {
  FilteringOptionsFetchResponse(this.options);

  final FilteringOptions options;
}
