//  視聴履歴のリポジトリ
abstract class WatchHistoryRepository {
  //  指定した動画の視聴日時を取得する。
  //  (未視聴の場合はnullを返す。)
  Future<DateTime> getWatchedAt(String videoId);

  //  指定した動画の視聴日時を保存する。
  Future<void> saveWatchedAt(String videoId, DateTime watchedAt);
}
