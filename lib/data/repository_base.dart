import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'repository_base.freezed.dart';

//  任意の操作に対する履歴を管理するリポジトリの基本実装
//  (ID文字列をキーとし、操作日時を値とする順序つきMapデータを管理する。)
class RepositoryBase {
  RepositoryBase(this.dbFileName);

  //  ローカルDBのファイル名
  final String dbFileName;

  //  HiveのBox
  Box<DateTime> _box = null;

  //  オンメモリのキャッシュ
  //  古いものから新しいものへの順に追加されていく。
  LinkedHashMap<String, DateTime> _onMemoryCache = null;

  //  全データを取得する。
  //  データが1つも存在しない場合は空データを返す。
  Future<List<Record>> getAll() async {
    await this._loadFromDatabaseIfNeeded();

    return this
        ._onMemoryCache
        .entries
        .map((e) => Record(e.key, e.value))
        .toList(growable: false);
  }

  //  指定されたIDに対応する日時を取得する。
  //  存在しない場合はnullを返す。
  Future<DateTime> get(String id) async {
    await this._loadFromDatabaseIfNeeded();

    return this._onMemoryCache[id];
  }

  //  操作日時を保存する。
  //  すでに記録がある場合、新しく上書きされる。
  //  日時にnullを指定した場合、そのIDの記録が削除される。
  Future<void> save(String id, DateTime operatedAt) async {
    await this._loadFromDatabaseIfNeeded();

    //  記録の更新を行う。
    if (operatedAt != null) {
      //  上書き操作を行うため、古い記録は削除してしまう。
      //  (LinkedHashMapは追加順を保持するため、置換ではなく、新規に入れ直す。)
      this._onMemoryCache.remove(id);
      this._onMemoryCache[id] = operatedAt;

      //  ローカルDBにも反映させる。
      await this._updateItemFromDatabase(id, operatedAt);
    }

    //  記録の削除を行う。
    else {
      //  正常に削除できた場合 (既に古いデータが存在していた場合)、ローカルDBからも削除する。
      final removedItem = this._onMemoryCache.remove(id);
      if (removedItem != null) await this._removeItemFromDatabase(id);
    }
  }

  //  必要に応じてローカルDBからデータを読み込む。
  Future<bool> _loadFromDatabaseIfNeeded() async {
    if (this._onMemoryCache != null) return false;

    //  DBから読み出して、String-DateTimeのMapに変換して、日時でソートする。
    this._box = await Hive.openBox(this.dbFileName);
    final entries = this
        ._box
        .toMap()
        .entries
        .map((e) => MapEntry<String, DateTime>(e.key.toString(), e.value))
        .sortedBy((e) => e.value);

    //  オンメモリキャッシュの初期状態として詰める。
    //  ignore: prefer_collection_literals
    this._onMemoryCache = LinkedHashMap<String, DateTime>();
    this._onMemoryCache.addEntries(entries);

    return true;
  }

  //  ローカルDBから指定したIDの項目を削除する。
  Future<void> _removeItemFromDatabase(String id) async {
    await this._box.delete(id);
  }

  //  ローカルDBの指定したIDの項目を更新する。
  Future<void> _updateItemFromDatabase(String id, DateTime operatedAt) async {
    //  存在しなければ新規に生成され、存在すれば上書きされる。
    await this._box.put(id, operatedAt);
  }
}

@freezed
abstract class Record with _$Record {
  const factory Record(String id, DateTime operatedAt) = _Record;
}
