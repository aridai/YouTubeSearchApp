import 'package:get_it/get_it.dart';
import 'package:youtube_search_app/env/env.dart';
import 'package:youtube_search_app/search/search_page_bloc.dart';
import 'package:youtube_search_app/search/usecase/append/stub_video_list_append_interactor.dart';
import 'package:youtube_search_app/search/usecase/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch/stub_video_list_fetch_interactor.dart';
import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/search/usecase/stub_repository.dart';

//  DIコンテナのラッパ
class Dependency {
  //  依存関係の設定を行う。
  static void setup() {
    GetIt.I.registerSingleton(
      Env.youtubeApiKey,
      instanceName: 'YOUTUBE_API_KEY',
    );

    GetIt.I.registerLazySingleton(() => StubRepository());

    GetIt.I.registerFactory<VideoListFetchUseCase>(
      () => StubVideoListFetchInteractor(resolve()),
    );
    GetIt.I.registerFactory<VideoListAppendUseCase>(
      () => StubVideoListAppendInteractor(resolve()),
    );

    GetIt.I.registerFactory<SearchPageBloc>(
      () => SearchPageBloc(resolve(), resolve()),
    );
  }

  //  依存関係の解決を行う。
  static T resolve<T>({String name}) => GetIt.I.get(instanceName: name);
}
