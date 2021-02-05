import 'package:youtube_search_app/application/search/filter/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/model/filtering_options.dart';

class StubFilteringOptionsFetchInteractor
    implements FilteringOptionsFetchUseCase {
  @override
  FilteringOptionsFetchResponse execute(FilteringOptionsFetchRequest request) =>
      FilteringOptionsFetchResponse(
        FilteringOptions(true, false, false, const RegexFiltering.none()),
      );
}
