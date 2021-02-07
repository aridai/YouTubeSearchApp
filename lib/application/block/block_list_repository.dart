//  ブロックリストのリポジトリ
abstract class BlockListRepository {
  //  指定された動画のブロック日時を取得する。
  //  (ブロックされていなければnullを返す。)
  Future<DateTime> getVideoBlockedAt(String videoId);

  //  指定されたチャンネルがブロック日時を取得する。
  //  (ブロックされていなければnullを返す。)
  Future<DateTime> getChannelBlockedAt(String channelId);
}
