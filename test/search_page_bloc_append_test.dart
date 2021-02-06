import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:youtube_search_app/application/fetch_error_type.dart';
import 'package:youtube_search_app/application/search/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/model/dummy_video.dart';
import 'package:youtube_search_app/ui/search/list/list_element.dart';
import 'package:youtube_search_app/ui/search/search_page_bloc.dart';

import 'matchers.dart';
import 'mocks.dart';

void main() {
  group('SearchPageBlocのテスト', () {
    final mockFetchUseCase = MockVideoListFetchUseCase();
    final mockAppendUseCase = MockVideoListAppendUseCase();
    final mockReloadUseCase = MockVideoListReloadUseCase();
    final mockHistoryUseCase = MockWatchHistorySaveUseCase();

    final bloc = SearchPageBloc(
      mockFetchUseCase,
      mockAppendUseCase,
      mockReloadUseCase,
      mockHistoryUseCase,
    );
    const keyword = '検索キーワードてすと';

    group('追加取得のテスト', () {
      test('追加取得に成功するケース', () async {
        //  最初の検索をするところまで進める。
        await runFirstTimeSearch(bloc, mockFetchUseCase, keyword);

        //  呼び出し回数などをリセットする。
        reset(mockFetchUseCase);

        //  追加取得に成功し、8件の動画が見つかり、追加取得が可能
        //  という結果を返すように設定する。
        final videoList = List.generate(8, (_) => DummyVideo.create());
        const hasNextPage = true;
        final response =
            VideoListAppendResponse.success(videoList, hasNextPage);
        when(mockAppendUseCase.execute(any)).thenAnswer((_) async => response);

        //  追加取得を行う。
        await bloc.fetchAdditionally();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockAppendUseCase.execute(any)).called(1);

        //  リストが更新されているはず。
        expect(
          bloc.list,
          emits(
            listPredicate(
              //  動画8件と末尾のProgressIndicator要素で、合わせて9件のはず。
              (l) => l.length == 9 && l.last is ProgressIndicatorElement,
            ),
          ),
        );

        //  動画リストが空でないはず。
        expect(bloc.isNotEmpty, emits(equals(true)));
      });

      test('追加取得に失敗するケース', () async {
        //  呼び出し回数などをリセットする。
        reset(mockFetchUseCase);

        //  errorStreamをReplaySubjectで記録する。
        final errorStream = ReplaySubject<FetchErrorType>()
          ..addStream(bloc.errorStream);

        //  追加取得に失敗するように設定する。
        const error = FetchErrorType.UnknownError;
        when(mockAppendUseCase.execute(any)).thenAnswer(
            (_) async => const VideoListAppendResponse.failure(error));

        //  追加取得を行う。
        await bloc.fetchAdditionally();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockAppendUseCase.execute(any)).called(1);

        //  エラーが通知されているはず。
        expect(errorStream, emits(equals(error)));

        //  追加取得時は失敗すると元のリストの内容のまま、次の追加取得が無効化される。
        expect(
          bloc.list,
          emits(
            listPredicate(
              //  末尾のProgressIndicator要素がなくなったため、全部で8件になっているはず。
              (l) => l.length == 8 && l.every((e) => e is VideoElement),
            ),
          ),
        );

        //  動画リストが空でないはず。
        expect(bloc.isNotEmpty, emits(equals(true)));
      });
    });
  });
}

//  最初の検索部分まで処理を進める。
Future<void> runFirstTimeSearch(
  SearchPageBloc bloc,
  MockVideoListFetchUseCase mockFetchUseCase,
  String keyword,
) async {
  when(mockFetchUseCase.execute(any)).thenAnswer(
    (_) async => VideoListFetchResponse.success(
      List.generate(1, (_) => DummyVideo.create()),
      true,
    ),
  );

  bloc.keywordSink.add(keyword);
  await bloc.search();

  //  現在、動画リスト1件で追加取得可能な状態となっている。
  expect(
    bloc.list,
    emits(
      listPredicate(
        (l) => l.length == 2 && l.last is ProgressIndicatorElement,
      ),
    ),
  );
}
