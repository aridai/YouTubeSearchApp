import 'package:rxdart/rxdart.dart';
import 'package:youtube_search_app/search/list_element.dart';
import 'package:youtube_search_app/search/usecase/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/video.dart';

//  検索ページのBLoC
class SearchPageBloc {
  SearchPageBloc(this._videoListFetchUseCase, this._videoListAppendUseCase);

  final VideoListFetchUseCase _videoListFetchUseCase;
  final VideoListAppendUseCase _videoListAppendUseCase;

  //  検索キーワード
  final _keyword = BehaviorSubject.seeded('');

  //  動画リスト
  final _videoList = BehaviorSubject<List<Video>>.seeded(List.empty());

  //  動画リスト末尾に要素を追加可能かどうか
  final _isAppendable = BehaviorSubject.seeded(false);

  //  取得中かどうか
  //  (検索キーワードの入力でEnterが押された直後の状態)
  final _isFetching = BehaviorSubject.seeded(false);

  //  スワイプ更新中かどうか
  //  (スワイプによる更新が行われている状態)
  final _isSwipeRefreshing = BehaviorSubject.seeded(false);

  //  追加取得中かどうか
  //  (リスト末尾まで到達した際の追加取得が行われている状態)
  final _isFetchingAdditionally = BehaviorSubject.seeded(false);

  //  ビジー状態 (通信状態) かどうか
  //  (3通りの更新処理のうち、いずれかが行われているかどうか)
  Stream<bool> get _isBusy => Rx.combineLatest3<bool, bool, bool, bool>(
        this._isFetching,
        this._isSwipeRefreshing,
        this._isFetchingAdditionally,
        (fetch, swipe, add) => fetch || swipe || add,
      );

  //  検索キーワードのStream
  Stream<String> get keyword => this._keyword.stream;

  //  検索キーワードのSink
  Sink<String> get keywordSink => this._keyword.sink;

  //  検索ページリスト
  Stream<List<ListElement>> get list => Rx.combineLatest2(
      this._videoList, this._isAppendable, this._toSearchPageList);

  //  リストが空ではないかどうか
  Stream<bool> get isNotEmpty => this.list.map((list) => list.isNotEmpty);

  //  取得中のProgressIndicatorを配置してもよいかどうか
  Stream<bool> get isProgressIndicatorVisible => this._isFetching.stream;

  //  終了処理を行う。
  void dispose() {
    this._videoList.close();
    this._isAppendable.close();
    this._isFetching.close();
    this._isSwipeRefreshing.close();
    this._isFetchingAdditionally.close();
  }

  //  検索を行う。
  Future<void> search() async {
    //  すでに他の通信処理が始まっている場合は新規に処理は走らせない。
    if (await this._isBusy.first) return;

    this._isFetching.add(true);

    final request = VideoListFetchRequest(this._keyword.value, null);
    final response = await this._videoListFetchUseCase.execute(request);

    //  成功時
    if (response is VideoListFetchResponseSuccess)
      this._onFetchSuccess(response.videoList, response.hasNextPage);

    //  失敗時
    if (response is VideoListFetchResponseFailure)
      this._onFetchFailure(response.cause, clearListOnError: true);

    this._isFetching.add(false);
  }

  //  スワイプ更新を行う。
  Future<void> refresh() async {
    //  すでに他の通信処理が始まっている場合は新規に処理は走らせない。
    if (await this._isBusy.first) return;

    this._isSwipeRefreshing.add(true);

    final request = VideoListFetchRequest(this._keyword.value, null);
    final response = await this._videoListFetchUseCase.execute(request);

    //  成功時
    if (response is VideoListFetchResponseSuccess)
      this._onFetchSuccess(response.videoList, response.hasNextPage);

    //  失敗時
    if (response is VideoListFetchResponseFailure)
      this._onFetchFailure(response.cause, clearListOnError: false);

    this._isSwipeRefreshing.add(false);
  }

  //  追加取得を行う。
  Future<void> fetchAdditionally() async {
    //  すでに他の通信処理が始まっている場合は新規に処理は走らせない。
    if (await this._isBusy.first) return;

    this._isFetchingAdditionally.add(true);

    final request = VideoListAppendRequest();
    final response = await this._videoListAppendUseCase.execute(request);

    //  成功時
    if (response is VideoListAppendResponseSuccess)
      this._onFetchSuccess(response.videoList, response.hasNextPage);

    //  失敗時
    if (response is VideoListAppendResponseFailure)
      this._onFetchFailure(response.cause, clearListOnError: false);

    this._isFetchingAdditionally.add(false);
  }

  //  動画リストを検索ページで表示させるためのリストに変換する。
  List<ListElement> _toSearchPageList(List<Video> videos, bool isAppendable) {
    //  追加取得が可能な場合のみ、ProgressIndicator要素を末尾に付加する。
    if (isAppendable) {
      final totalSize = videos.length + 1;
      final lastIndex = videos.length;

      return List.generate(
        totalSize,
        (i) => (i != lastIndex)
            ? VideoElement(videos[i])
            : ProgressIndicatorElement(),
      );
    } else {
      return List.generate(videos.length, (i) => VideoElement(videos[i]));
    }
  }

  //  動画リストの取得に成功したとき。
  void _onFetchSuccess(List<Video> newVideoList, bool hasNextPage) {
    this._videoList.add(newVideoList);
    this._isAppendable.add(hasNextPage);
  }

  //  動画リストの取得に失敗したとき。
  void _onFetchFailure(FetchErrorType cause, {bool clearListOnError = true}) {
    //  TODO: エラー通知系Streamの発火

    if (clearListOnError) this._videoList.add(List.empty());
    this._isAppendable.add(false);
  }
}
