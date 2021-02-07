import 'dart:collection';

import 'package:youtube_search_app/application/block/block_list_repository.dart';

class BlockListRepositoryImpl implements BlockListRepository {
  //  ブロックされた動画のIDと日時のオンメモリキャッシュ
  LinkedHashMap<String, DateTime> _blockedVideos = null;

  //  ブロックされたチャンネルのIDと日時のオンメモリキャッシュ
  LinkedHashMap<String, DateTime> _blockedChannels = null;

  //  指定された動画のブロック日時を取得する。
  @override
  Future<DateTime> getVideoBlockedAt(String videoId) async {
    await this._loadBlockedVideosFromDatabase();

    return this._blockedVideos[videoId];
  }

  //  指定されたチャンネルのブロック日時を取得する。
  @override
  Future<DateTime> getChannelBlockedAt(String channelId) async {
    await this._loadBlockedChannelsFromDatabase();

    return this._blockedChannels[channelId];
  }

  Future<bool> _loadBlockedVideosFromDatabase() async {
    if (this._blockedVideos != null) return false;

    //  TODO: ローカルDBからの読み出し & ソート & オンメモリLinkedHashMapへのキャッシュ
    //  ignore: prefer_collection_literals
    this._blockedVideos = LinkedHashMap<String, DateTime>();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    return true;
  }

  Future<bool> _loadBlockedChannelsFromDatabase() async {
    if (this._blockedChannels != null) return false;

    //  TODO: ローカルDBからの読み出し & ソート & オンメモリLinkedHashMapへのキャッシュ
    //  ignore: prefer_collection_literals
    this._blockedChannels = LinkedHashMap<String, DateTime>();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    return true;
  }
}
