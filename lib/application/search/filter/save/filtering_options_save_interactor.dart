import 'package:youtube_search_app/application/search/filter/filtering_options_repository.dart';
import 'package:youtube_search_app/application/search/filter/save/filtering_options_save_use_case.dart';

class FilteringOptionsSaveInteractor implements FilteringOptionsSaveUseCase {
  FilteringOptionsSaveInteractor(this._repository);

  final FilteringOptionsRepository _repository;

  @override
  FilteringOptionsSaveResponse execute(FilteringOptionsSaveRequest request) {
    //  TODO: Futureの待機
    this._repository.saveOptions(request.options);

    return FilteringOptionsSaveResponse();
  }
}
