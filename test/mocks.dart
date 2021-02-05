import 'package:mockito/mockito.dart';
import 'package:youtube_search_app/application/history/save/watch_history_save_use_case.dart';
import 'package:youtube_search_app/application/search/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/save/filtering_options_save_use_case.dart';

//  VideoListFetchUseCaseのモック
class MockVideoListFetchUseCase extends Mock implements VideoListFetchUseCase {}

//  VideoListAppendUseCaseのモック
class MockVideoListAppendUseCase extends Mock
    implements VideoListAppendUseCase {}

//  WatchHistorySaveUseCaseのモック
class MockWatchHistorySaveUseCase extends Mock
    implements WatchHistorySaveUseCase {}

//  FilteringOptionsFetchUseCaseのモック
class MockFilteringOptionsFetchUseCase extends Mock
    implements FilteringOptionsFetchUseCase {}

//  FilteringOptionsSaveUseCaseのモック
class MockFilteringOptionsSaveUseCase extends Mock
    implements FilteringOptionsSaveUseCase {}
