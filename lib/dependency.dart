import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_search_app/application/block/block_list_repository.dart';
import 'package:youtube_search_app/application/history/watch/current_date_time_provider.dart';
import 'package:youtube_search_app/application/history/watch/save/watch_history_save_interactor.dart';
import 'package:youtube_search_app/application/history/watch/save/watch_history_save_use_case.dart';
import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';
import 'package:youtube_search_app/application/search/append/video_list_append_interactor.dart';
import 'package:youtube_search_app/application/search/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_interactor.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/fetch/stub_filtering_options_fetch_interactor.dart';
import 'package:youtube_search_app/application/search/filter/save/filtering_options_save_use_case.dart';
import 'package:youtube_search_app/application/search/filter/save/stub_filtering_options_save_interactor.dart';
import 'package:youtube_search_app/application/search/reload/video_list_reload_interactor.dart';
import 'package:youtube_search_app/application/search/reload/video_list_reload_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/data/api/youtube_api_service.dart';
import 'package:youtube_search_app/data/block/block_list_repository_impl.dart';
import 'package:youtube_search_app/data/history/watch/watch_history_repository_impl.dart';
import 'package:youtube_search_app/data/search/search_repository_impl.dart';
import 'package:youtube_search_app/env/env.dart';
import 'package:youtube_search_app/ui/filter/dialog/filter_dialog_bloc.dart';
import 'package:youtube_search_app/ui/search/search_page_bloc.dart';

//  DIコンテナのラッパ
class Dependency {
  //  依存関係の設定を行う。
  static void setup() {
    GetIt.I.registerSingleton(
      Env.youtubeApiKey,
      instanceName: 'YOUTUBE_API_KEY',
    );

    GetIt.I.registerLazySingleton<CurrentDateTimeProvider>(
      () => CurrentDateTimeProvider(),
    );

    GetIt.I.registerLazySingleton<YouTubeApiService>(
      () => YouTubeApiService(Dio()),
    );
    GetIt.I.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(resolve(), resolve(name: 'YOUTUBE_API_KEY')),
    );
    GetIt.I.registerLazySingleton<WatchHistoryRepository>(
      () => WatchHistoryRepositoryImpl(),
    );
    GetIt.I.registerLazySingleton<BlockListRepository>(
      () => BlockListRepositoryImpl(),
    );

    GetIt.I.registerFactory<VideoListFetchUseCase>(
      () => VideoListFetchInteractor(resolve(), resolve(), resolve()),
    );
    GetIt.I.registerFactory<VideoListAppendUseCase>(
      () => VideoListAppendInteractor(resolve(), resolve(), resolve()),
    );
    GetIt.I.registerFactory<VideoListReloadUseCase>(
      () => VideoListReloadInteractor(resolve(), resolve(), resolve()),
    );
    GetIt.I.registerFactory<WatchHistorySaveUseCase>(
      () => WatchHistorySaveInteractor(resolve(), resolve()),
    );
    GetIt.I.registerFactory<FilteringOptionsFetchUseCase>(
      () => StubFilteringOptionsFetchInteractor(),
    );
    GetIt.I.registerFactory<FilteringOptionsSaveUseCase>(
      () => StubFilteringOptionsSaveInteractor(),
    );

    GetIt.I.registerFactory<SearchPageBloc>(
      () => SearchPageBloc(resolve(), resolve(), resolve(), resolve()),
    );
    GetIt.I.registerFactory<FilterDialogBloc>(
      () => FilterDialogBloc(resolve(), resolve()),
    );
  }

  //  依存関係の解決を行う。
  static T resolve<T>({String name}) => GetIt.I.get(instanceName: name);
}
