import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:youtube_search_app/application/fetch_error_type.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/model/dummy_video.dart';
import 'package:youtube_search_app/model/filtering_options.dart';
import 'package:youtube_search_app/ui/search/list/list_element.dart';
import 'package:youtube_search_app/ui/search/search_page_bloc.dart';

import 'matchers.dart';
import 'mocks.dart';

void main() {
  group('SearchPageBlocのテスト', () {
    final mockOptionsUseCase = MockFilteringOptionsFetchUseCase();
    final mockFetchUseCase = MockVideoListFetchUseCase();
    final mockAppendUseCase = MockVideoListAppendUseCase();
    final mockReloadUseCase = MockVideoListReloadUseCase();
    final mockHistoryUseCase = MockWatchHistorySaveUseCase();

    when(mockOptionsUseCase.execute(any)).thenReturn(
      FilteringOptionsFetchResponse(
          const FilteringOptions(true, false, false, RegexFiltering.none())),
    );

    final bloc = SearchPageBloc(
      mockOptionsUseCase,
      mockFetchUseCase,
      mockAppendUseCase,
      mockReloadUseCase,
      mockHistoryUseCase,
    );
    const keyword = '検索キーワードてすと';

    group('スワイプ更新のテスト', () {
      test('スワイプ更新に成功するケース', () async {
        //  最初の検索をするところまで進める。
        await runFirstTimeSearch(bloc, mockFetchUseCase, keyword);

        //  呼び出し回数などをリセットする。
        reset(mockFetchUseCase);

        //  スワイプ更新に成功し、4件の動画が見つかり、追加取得が可能
        //  という結果を返すように設定する。
        final videoList = List.generate(4, (_) => DummyVideo.create());
        const hasNextPage = true;
        final response = VideoListFetchResponse.success(videoList, hasNextPage);
        when(mockFetchUseCase.execute(any)).thenAnswer((_) async => response);

        //  スワイプ更新を掛ける。
        await bloc.refresh();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockFetchUseCase.execute(argThat(searchKeywordEquals(keyword))))
            .called(1);

        //  リストが更新されているはず。
        expect(
          bloc.list,
          emits(
            listPredicate(
              //  動画4件と末尾のProgressIndicator要素で、合わせて5件のはず。
              (l) => l.length == 5 && l.last is ProgressIndicatorElement,
            ),
          ),
        );

        //  動画リストが空でないことが通知されているはず。
        expect(bloc.isNotEmpty, emits(equals(true)));
      });

      test('スワイプ更新に失敗するケース', () async {
        //  呼び出し回数などをリセットする。
        reset(mockFetchUseCase);

        //  errorStreamをReplaySubjectで記録する。
        final errorStream = ReplaySubject<FetchErrorType>()
          ..addStream(bloc.errorStream);

        //  スワイプ更新に失敗するように設定する。
        const error = FetchErrorType.ClientError;
        when(mockFetchUseCase.execute(any)).thenAnswer(
          (_) async => const VideoListFetchResponse.failure(error),
        );

        //  スワイプ更新を掛ける。
        await bloc.refresh();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockFetchUseCase.execute(argThat(searchKeywordEquals(keyword))))
            .called(1);

        //  エラーが通知されているはず。
        expect(errorStream, emits(equals(error)));

        //  スワイプ更新時は失敗しても動画リストをクリアしない。
        //  そのため、リストが更新前の状態であるはず。
        expect(
          bloc.list,
          emits(
            listPredicate(
              //  動画4件と末尾のProgressIndicator要素で、合わせて5件のはず。
              (l) => l.length == 5 && l.last is ProgressIndicatorElement,
            ),
          ),
        );

        //  動画リストが空でないと判定されるはず。
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
      List.generate(2, (_) => DummyVideo.create()),
      false,
    ),
  );

  bloc.keywordSink.add(keyword);
  await bloc.search();

  //  現在、動画リスト2件で追加取得不可能な状態となっている。
  expect(
    bloc.list,
    emits(
      listPredicate(
        (l) => l.length == 2 && l.every((e) => e is VideoElement),
      ),
    ),
  );
}
