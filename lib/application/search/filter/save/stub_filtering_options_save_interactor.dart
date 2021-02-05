import 'package:youtube_search_app/application/search/filter/save/filtering_options_save_use_case.dart';

class StubFilteringOptionsSaveInteractor
    implements FilteringOptionsSaveUseCase {
  @override
  FilteringOptionsSaveResponse execute(FilteringOptionsSaveRequest request) =>
      FilteringOptionsSaveResponse();
}
