import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';
import 'package:youtube_search_app/application/search/reload/video_list_reload_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/application/search/video_converter.dart';
import 'package:youtube_search_app/model/video.dart';
import 'package:youtube_search_app/model/video_item.dart';

class VideoListReloadInteractor implements VideoListReloadUseCase {
  VideoListReloadInteractor(
    this._searchRepository,
    this._watchHistoryRepository,
  );

  final SearchRepository _searchRepository;
  final WatchHistoryRepository _watchHistoryRepository;

  @override
  Future<VideoListReloadResponse> execute(
      VideoListReloadRequest request) async {
    final result = this._searchRepository.getSearchResult();

    //  TODO: フィルタリング処理
    final videoList = await Future.wait(
      result.videos.map((item) async => this.toVideo(item)),
    );

    //  TODO: 検索履歴の更新

    return VideoListReloadResponse(videoList, result.hasNextPage);
  }

  Future<Video> toVideo(VideoItem item) async {
    final watchedAt =
        await this._watchHistoryRepository.getWatchedAt(item.videoId);

    //  TODO: ブロックデータの取得処理
    const isBlockedVideo = false;
    const isBlockedChannel = false;

    return VideoConverter.convert(
      item,
      watchedAt,
      isBlockedVideo,
      isBlockedChannel,
    );
  }
}
