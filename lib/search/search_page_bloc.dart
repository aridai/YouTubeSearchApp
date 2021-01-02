import 'package:rxdart/rxdart.dart';
import 'package:youtube_search_app/dummy_video.dart';
import 'package:youtube_search_app/search/list_element.dart';
import 'package:youtube_search_app/video.dart';

//  検索ページのBLoC
class SearchPageBloc {
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

    print('検索開始');
    this._isFetching.add(true);

    await this._dummyDelayForDebug();
    this._updateListForDebug(5, isAppendable: true);

    this._isFetching.add(false);
    print('検索終了');
  }

  //  スワイプ更新を行う。
  Future<void> refresh() async {
    //  すでに他の通信処理が始まっている場合は新規に処理は走らせない。
    if (await this._isBusy.first) return;

    print('スワイプ更新開始');
    this._isSwipeRefreshing.add(true);

    await this._dummyDelayForDebug();
    this._updateListForDebug(5, isAppendable: true);

    this._isSwipeRefreshing.add(false);
    print('スワイプ更新終了');
  }

  //  追加取得を行う。
  Future<void> fetchAdditionally() async {
    //  すでに他の通信処理が始まっている場合は新規に処理は走らせない。
    if (await this._isBusy.first) return;

    print('追加取得開始');
    this._isFetchingAdditionally.add(true);

    await this._dummyDelayForDebug();
    final destSize = this._videoList.value.length + 5;
    this._updateListForDebug(destSize, isAppendable: destSize < 20);

    this._isFetchingAdditionally.add(false);
    print('追加取得終了');
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

  //  ダミーの遅延を掛ける。
  //  (デバッグ用)
  Future<void> _dummyDelayForDebug() =>
      Future.delayed(const Duration(seconds: 3));

  //  要素数を指定してリストを更新する。
  //  (デバッグ用)
  void _updateListForDebug(int size, {bool isAppendable = true}) {
    this._isAppendable.add(isAppendable);
    this._videoList.add(List.generate(size, (index) => DummyVideo()));
  }
}
