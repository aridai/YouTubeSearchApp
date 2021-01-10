import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:youtube_search_app/dummy_video.dart';
import 'package:youtube_search_app/search/list_element.dart';
import 'package:youtube_search_app/search/search_page_bloc.dart';
import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

import 'matchers.dart';
import 'mocks.dart';

void main() {
  group('SearchPageBlocのテスト', () {
    final mockFetchUseCase = MockVideoListFetchUseCase();
    final mockAppendUseCase = MockVideoListAppendUseCase();
    final mockHistoryUseCase = MockWatchHistorySaveUseCase();

    final bloc = SearchPageBloc(
      mockFetchUseCase,
      mockAppendUseCase,
      mockHistoryUseCase,
    );

    group('検索のテスト', () {
      test('成功するケース', () async {
        final videoList = List.generate(3, (_) => DummyVideo());
        const hasNextPage = true;
        final response = VideoListFetchResponseSuccess(videoList, hasNextPage);

        //  ProgressIndicatorの可視性を通知するStreamを記録する。
        final isProgressIndicatorVisible = ReplaySubject<bool>()
          ..addStream(bloc.isProgressIndicatorVisible);

        //  検索に成功し、3件の動画が見つかり、追加取得が可能
        //  という結果を返すように設定する。
        when(mockFetchUseCase.execute(any)).thenAnswer((_) async => response);

        //  検索キーワードを入力する。
        const keyword = '検索のテスト成功するケースのキーワード';
        bloc.keywordSink.add(keyword);

        //  検索処理を走らせる。
        await bloc.search();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockFetchUseCase.execute(argThat(searchKeywordEquals(keyword))))
            .called(1);

        //  検索処理の前後でProgressIndicatorが非表示→表示→非表示となったはず。
        expect(
            isProgressIndicatorVisible,
            emitsInOrder(<Matcher>[
              equals(false),
              equals(true),
              equals(false),
            ]));

        //  動画リストが更新されているはず。
        expect(
          bloc.list,
          emits(
            listPredicate(
                //  動画3件に加え、末尾のProgressIndicator要素で要素数が4であるはず。
                (l) => l.length == 4 && l.last is ProgressIndicatorElement),
          ),
        );

        //  動画リストが空ではないことが通知されているはず。
        expect(bloc.isNotEmpty, emits(equals(true)));
      });

      test('失敗するケース', () async {
        const error = FetchErrorType.TokenError;
        final response = VideoListFetchResponseFailure(error);

        //  errorStreamの発火記録をReplaySubjectで記録しておく。
        final errorStream = ReplaySubject<FetchErrorType>()
          ..addStream(bloc.errorStream);

        //  検索に失敗する結果を返すように設定する。
        when(mockFetchUseCase.execute(any)).thenAnswer((_) async => response);

        //  検索キーワードを入力する。
        const keyword = '検索のテスト失敗するケースのキーワード';
        bloc.keywordSink.add(keyword);

        //  検索処理を走らせる。
        await bloc.search();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockFetchUseCase.execute(argThat(searchKeywordEquals(keyword))))
            .called(1);

        //  エラーが通知されているはず。
        expect(errorStream, emits(equals(error)));

        //  動画リストが空であることが通知されているはず。
        expect(bloc.isNotEmpty, emits(equals(false)));
      });

      test('取得自体には成功するが、動画リストが空であるケース', () async {
        final videoList = List<Video>.empty();
        const hasNextPage = false;
        final response = VideoListFetchResponseSuccess(videoList, hasNextPage);

        //  検索に成功するが、1件も動画が見つからず、追加取得も不可能
        //  という結果を返すように設定する。
        when(mockFetchUseCase.execute(any)).thenAnswer((_) async => response);

        //  検索キーワードを入力する。
        const keyword = '取得自体には成功するが、動画リストが空であるケースのキーワード';
        bloc.keywordSink.add(keyword);

        //  検索処理を走らせる。
        await bloc.search();

        //  ユースケースインタラクタが呼ばれたはず。
        verify(mockFetchUseCase.execute(argThat(searchKeywordEquals(keyword))))
            .called(1);

        //  動画リストが空であることが通知されているはず。
        expect(bloc.isNotEmpty, emits(equals(false)));
      });
    });
  });
}
