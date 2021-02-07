import 'dart:collection';

import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';

class WatchHistoryRepositoryImpl implements WatchHistoryRepository {
  //  オンメモリのキャッシュ
  //  古いものから新しいものへの順に追加されていく。
  LinkedHashMap<String, DateTime> _map = null;

  //  指定された動画の視聴日時を返す。
  @override
  Future<DateTime> getWatchedAt(String videoId) async {
    await this._loadWatchHistoryListFromDatabase();

    return this._map[videoId];
  }

  //  視聴日時を保存する。
  @override
  Future<void> saveWatchedAt(String videoId, DateTime watchedAt) async {
    await this._loadWatchHistoryListFromDatabase();

    //  TODO: DBへの保存
    await Future<void>.delayed(const Duration(milliseconds: 50));

    //  既に視聴済みである場合、削除を行ってから新規に入れ直す。
    //  (LinkedHashMapへの追加順が視聴順となるようにするため。)
    this._map.remove(videoId);
    this._map[videoId] = watchedAt;

    final histories = this
        ._map
        .entries
        .map((e) => '{ id=${e.key}, at=${e.value} }')
        .join(', ');
    print('視聴履歴: $histories');
  }

  Future<bool> _loadWatchHistoryListFromDatabase() async {
    if (this._map != null) return false;

    //  TODO: ローカルDBからの読み出し & ソート & オンメモリLinkedHashMapへのキャッシュ
    //  ignore: prefer_collection_literals
    this._map = LinkedHashMap<String, DateTime>();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    return true;
  }
}
