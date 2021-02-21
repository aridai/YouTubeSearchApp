import 'package:youtube_search_app/application/search/filter/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/filtering_options_repository.dart';

class FilteringOptionsFetchInteractor implements FilteringOptionsFetchUseCase {
  FilteringOptionsFetchInteractor(this._repository);

  final FilteringOptionsRepository _repository;

  @override
  FilteringOptionsFetchResponse execute(FilteringOptionsFetchRequest request) {
    final options = this._repository.getOptions();

    return FilteringOptionsFetchResponse(options);
  }
}
