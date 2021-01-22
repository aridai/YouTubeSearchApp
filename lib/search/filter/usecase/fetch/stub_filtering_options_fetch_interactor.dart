import 'package:youtube_search_app/search/filter/filtering_options.dart';
import 'package:youtube_search_app/search/filter/usecase/fetch/filtering_options_fetch_use_case.dart';

class StubFilteringOptionsFetchInteractor
    implements FilteringOptionsFetchUseCase {
  @override
  FilteringOptionsFetchResponse execute(FilteringOptionsFetchRequest request) =>
      FilteringOptionsFetchResponse(
        FilteringOptions(true, false, false, const RegexFiltering.none()),
      );
}
