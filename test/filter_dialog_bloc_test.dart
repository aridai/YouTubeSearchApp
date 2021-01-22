import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:youtube_search_app/search/filter/filter_dialog_bloc.dart';
import 'package:youtube_search_app/search/filter/filtering_options.dart';
import 'package:youtube_search_app/search/filter/regex_filter_type.dart';
import 'package:youtube_search_app/search/filter/usecase/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/search/filter/usecase/save/filtering_options_save_use_case.dart';

import 'mocks.dart';

void main() {
  group('FilterDialogBlocのテスト', () {
    final mockFetchUseCase = MockFilteringOptionsFetchUseCase();
    final mockSaveUseCase = MockFilteringOptionsSaveUseCase();

    //  設定の初期値 (前回使用していた設定値) を設定する。
    const initIncludesWatchedVideos = false;
    const initIncludesBlockedVideos = true;
    const initIncludesBlockedChannels = false;
    const initRegexPatternString = '(.*)R18(.*)';
    const initRegexFiltering = RegexFiltering.black(initRegexPatternString);
    final initialOptions = FilteringOptions(
      initIncludesWatchedVideos,
      initIncludesBlockedVideos,
      initIncludesBlockedChannels,
      initRegexFiltering,
    );
    when(mockFetchUseCase.execute(any)).thenAnswer(
      (_) => FilteringOptionsFetchResponse(initialOptions),
    );

    final bloc = FilterDialogBloc(mockFetchUseCase, mockSaveUseCase);

    test('前回の設定から設定の初期値を復元するテスト', () {
      //  視聴済み動画の設定項目が初期値と同じはず。
      expect(
        bloc.includesWatchedVideos,
        emits(equals(initIncludesWatchedVideos)),
      );

      //  ブロック済み動画の設定項目が初期値と同じはず。
      expect(
        bloc.includesBlockedVideos,
        emits(equals(initIncludesBlockedVideos)),
      );

      //  ブロック済みチャンネルの設定項目が初期値と同じはず。
      expect(
        bloc.includesBlockedChannels,
        emits(equals(initIncludesBlockedChannels)),
      );

      //  正規表現フィルタの設定項目が初期値と同じはず。
      expect(
        bloc.regexFilterType,
        emits(equals(RegexFilterType.BLACK_LIST)),
      );
      expect(
        bloc.regexFilterPatternString,
        emits(equals(initRegexPatternString)),
      );
    });

    test('OKボタンの活性のテスト', () async {
      final isOKButtonEnabled = BehaviorSubject<bool>()
        ..addStream(bloc.isOKButtonEnabled);

      //  初期状態から何も操作していなければOKボタンは無効なはず。
      await expectLater(
        await isOKButtonEnabled.firstWhere((isEnabled) => !isEnabled),
        equals(false),
      );

      //  初期状態から何かしら操作を行うとOKボタンが有効となるはず。
      //  (視聴済み動画の設定項目を変更してみる。)
      bloc.onWatchedVideoFilterChanged(!initIncludesWatchedVideos);
      await expectLater(
        await isOKButtonEnabled.firstWhere((isEnabled) => isEnabled),
        equals(true),
      );

      //  初期状態と同じ状態に戻す操作を行うとOKボタンが再び無効となるはず。
      //  (視聴済み動画の設定項目を元に戻してみる。)
      bloc.onWatchedVideoFilterChanged(initIncludesWatchedVideos);
      await expectLater(
        await isOKButtonEnabled.firstWhere((isEnabled) => !isEnabled),
        equals(false),
      );

      //  正規表現文字列を変更するとOKボタンが有効になるはず。
      bloc.onRegexFilterPatternStringChanged('変更された正規表現文字列');
      await expectLater(
        await isOKButtonEnabled.firstWhere((isEnabled) => isEnabled),
        equals(true),
      );
    }, timeout: const Timeout(Duration(seconds: 1)));

    test('OKボタンを押すと設定値を保存するテスト', () {
      //  まだ保存処理は呼ばれていないはず。
      verifyNever(mockSaveUseCase.execute(any));

      //  オプションを色々と変更してみる。
      bloc.onWatchedVideoFilterChanged(true);
      bloc.onBlockedVideoFilterChanged(false);
      bloc.onBlockedChannelFilterChanged(true);
      bloc.onRegexFilterTypeChanged(RegexFilterType.BLACK_LIST);
      bloc.onRegexFilterPatternStringChanged('(.*)R15(.*)');

      final expectedOptions = FilteringOptions(
        true,
        false,
        true,
        const RegexFiltering.black('(.*)R15(.*)'),
      );

      //  OKボタンを押すと設定したオプションの保存処理が呼ばれるはず。
      bloc.onOKButtonClicked();
      verify(
        mockSaveUseCase.execute(argThat(predicate<FilteringOptionsSaveRequest>(
          (request) => request.options == expectedOptions,
        ))),
      ).called(equals(1));
      verifyNoMoreInteractions(mockSaveUseCase);
    });
  });
}
