import 'package:youtube_search_app/application/history/watch/save/watch_history_save_use_case.dart';

class StubWatchHistorySaveInteractor implements WatchHistorySaveUseCase {
  @override
  Future<WatchHistorySaveResponse> execute(
      WatchHistorySaveRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    return WatchHistorySaveResponse();
  }
}
