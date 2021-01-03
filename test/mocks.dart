import 'package:mockito/mockito.dart';
import 'package:youtube_search_app/search/usecase/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';

//  VideoListFetchUseCaseのモック
class MockVideoListFetchUseCase extends Mock implements VideoListFetchUseCase {}

//  VideoListAppendUseCaseのモック
class MockVideoListAppendUseCase extends Mock
    implements VideoListAppendUseCase {}
