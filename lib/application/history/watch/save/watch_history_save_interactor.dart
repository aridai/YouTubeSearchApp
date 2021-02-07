import 'package:youtube_search_app/application/history/watch/current_date_time_provider.dart';
import 'package:youtube_search_app/application/history/watch/save/watch_history_save_use_case.dart';
import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';

class WatchHistorySaveInteractor implements WatchHistorySaveUseCase {
  WatchHistorySaveInteractor(this._repository, this._timeProvider);

  final WatchHistoryRepository _repository;
  final CurrentDateTimeProvider _timeProvider;

  @override
  Future<WatchHistorySaveResponse> execute(
      WatchHistorySaveRequest request) async {
    final videoId = request.video.videoId;
    final watchedAt = this._timeProvider.provide();

    await this._repository.saveWatchedAt(videoId, watchedAt);

    return WatchHistorySaveResponse();
  }
}
