import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';
import 'package:youtube_search_app/data/repository_base.dart';

class WatchHistoryRepositoryImpl implements WatchHistoryRepository {
  final _base = RepositoryBase('watch');

  //  指定された動画の視聴日時を返す。
  @override
  Future<DateTime> getWatchedAt(String videoId) async {
    return await this._base.get(videoId);
  }

  //  視聴日時を保存する。
  @override
  Future<void> saveWatchedAt(String videoId, DateTime watchedAt) async {
    await this._base.save(videoId, watchedAt);
  }
}
