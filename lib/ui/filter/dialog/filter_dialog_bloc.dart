import 'package:rxdart/rxdart.dart';
import 'package:youtube_search_app/application/search/filter/fetch/filtering_options_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/filter/save/filtering_options_save_use_case.dart';
import 'package:youtube_search_app/model/filtering_options.dart';
import 'package:youtube_search_app/ui/filter/regex/regex_filter_type.dart';

//  FilterDialogのBLoC
class FilterDialogBloc {
  FilterDialogBloc(this._fetchUseCase, this._saveUseCase) {
    final response = this._fetchUseCase.execute(FilteringOptionsFetchRequest());
    final initial = response.options;

    //  フィルタリングオプションの各種項目の初期値を設定する。
    this._includesWatchedVideos.value = initial.includesWatchedVideos;
    this._includesBlockedVideos.value = initial.includesBlockedVideos;
    this._includesBlockedChannels.value = initial.includesBlockedChannels;
    initial.regexFiltering.when(
      none: () {
        this._regexFilterType.value = RegexFilterType.NONE;
        this._regexFilterPatternStr.value = '';
      },
      white: (pattern) {
        this._regexFilterType.value = RegexFilterType.WHITE_LIST;
        this._regexFilterPatternStr.value = pattern;
      },
      black: (pattern) {
        this._regexFilterType.value = RegexFilterType.BLACK_LIST;
        this._regexFilterPatternStr.value = pattern;
      },
    );

    //  OKボタンの有効性を通知するストリームを構築する。
    this._hasAnyChanges = this._createHasAnyChangesStream(initial);
  }

  final FilteringOptionsFetchUseCase _fetchUseCase;
  final FilteringOptionsSaveUseCase _saveUseCase;

  //  視聴済み動画を検索結果に含めるかどうか
  final _includesWatchedVideos = BehaviorSubject<bool>();

  //  ブロックした動画を検索結果に含めるかどうか
  final _includesBlockedVideos = BehaviorSubject<bool>();

  //  ブロックしたチャンネルの動画を検索結果に含めるかどうか
  final _includesBlockedChannels = BehaviorSubject<bool>();

  //  正規表現フィルタの種類
  final _regexFilterType = BehaviorSubject<RegexFilterType>();

  //  正規表現フィルタのパターン文字列
  final _regexFilterPatternStr = BehaviorSubject<String>();

  //  オプションに変更が存在するかどうか
  Stream<bool> _hasAnyChanges;

  //  視聴済み動画を検索結果に含めるかどうか
  Stream<bool> get includesWatchedVideos => this._includesWatchedVideos.stream;

  //  ブロックした動画を検索結果に含めるかどうか
  Stream<bool> get includesBlockedVideos => this._includesBlockedVideos.stream;

  //  ブロックしたチャンネルの動画を検索結果に含めるかどうか
  Stream<bool> get includesBlockedChannels =>
      this._includesBlockedChannels.stream;

  //  正規表現フィルタの種類
  Stream<RegexFilterType> get regexFilterType => this._regexFilterType.stream;

  //  正規表現フィルタのパターン文字列
  Stream<String> get regexFilterPatternString =>
      this._regexFilterPatternStr.stream;

  //  正規表現入力フィールドが有効な状態であるかどうか
  //  (正規表現フィルタが無効であるか、もしくは、有効である場合に空文字列ではないかどうか)
  Stream<bool> get isValidRegexFieldState =>
      Rx.combineLatest2<RegexFilterType, String, bool>(
        this.regexFilterType,
        this.regexFilterPatternString,
        (type, string) => type == RegexFilterType.NONE || string.isNotEmpty,
      );

  //  OKボタンの活性
  Stream<bool> get isOKButtonEnabled => Rx.combineLatest2<bool, bool, bool>(
        this._hasAnyChanges,
        this.isValidRegexFieldState,
        (anyChanges, valid) => anyChanges && valid,
      );

  //  視聴済み動画を検索結果に含めるかどうかの設定が変更されたとき。
  void onWatchedVideoFilterChanged(bool includes) =>
      this._includesWatchedVideos.value = includes;

  //  ブロックした動画を検索結果に含めるかどうかの設定が変更されたとき。
  void onBlockedVideoFilterChanged(bool includes) =>
      this._includesBlockedVideos.value = includes;

  //  ブロックしたチャンネルの動画を検索結果に含めるかどうかの設定が変更されたとき。
  void onBlockedChannelFilterChanged(bool includes) =>
      this._includesBlockedChannels.value = includes;

  //  正規表現フィルタの種類の設定が変更されたとき。
  void onRegexFilterTypeChanged(RegexFilterType type) =>
      this._regexFilterType.value = type;

  //  正規表現フィルタのパターン文字列が変更されたとき。
  void onRegexFilterPatternStringChanged(String pattern) =>
      this._regexFilterPatternStr.value = pattern;

  //  OKボタンが押されたとき。
  void onOKButtonClicked() {
    //  正規表現フィルタのオプションを組み立てる。
    final regex = this._regexFilterType.value.when(
          none: () => const RegexFiltering.none(),
          white: () => RegexFiltering.white(this._regexFilterPatternStr.value),
          black: () => RegexFiltering.black(this._regexFilterPatternStr.value),
        );

    //  フィルタリングオプションを組み立てる。
    final options = FilteringOptions(
      this._includesWatchedVideos.value,
      this._includesBlockedVideos.value,
      this._includesBlockedChannels.value,
      regex,
    );

    //  フィルタリングオプションを保存する。
    this._saveUseCase.execute(FilteringOptionsSaveRequest(options));
  }

  void dispose() {
    this._includesWatchedVideos.close();
    this._includesBlockedVideos.close();
    this._includesBlockedChannels.close();
    this._regexFilterType.close();
    this._regexFilterPatternStr.close();
  }

  //  変更が存在するかどうか通知するStreamを生成する。
  Stream<bool> _createHasAnyChangesStream(FilteringOptions initial) =>
      Rx.combineLatest5<bool, bool, bool, RegexFilterType, String, bool>(
        this._includesWatchedVideos,
        this._includesBlockedVideos,
        this._includesBlockedChannels,
        this._regexFilterType,
        this._regexFilterPatternStr,
        (watched, videos, channels, type, pattern) {
          //  正規表現フィルタが変更されているどうかを判定する。
          final isRegexFilteringChanged = initial.regexFiltering.when(
            none: () => type != RegexFilterType.NONE,
            white: (p) => type != RegexFilterType.WHITE_LIST || pattern != p,
            black: (p) => type != RegexFilterType.BLACK_LIST || pattern != p,
          );

          //  各種オプションが変更されているかどうかを判定する。
          return isRegexFilteringChanged ||
              watched != initial.includesWatchedVideos ||
              videos != initial.includesBlockedVideos ||
              channels != initial.includesBlockedChannels;
        },
      );
}
