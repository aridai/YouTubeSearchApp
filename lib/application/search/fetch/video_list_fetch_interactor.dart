import 'package:youtube_search_app/application/block/block_list_repository.dart';
import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';
import 'package:youtube_search_app/application/search/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/application/search/video_converter.dart';
import 'package:youtube_search_app/model/filtering_options.dart';
import 'package:youtube_search_app/model/video.dart';
import 'package:youtube_search_app/model/video_item.dart';

class VideoListFetchInteractor implements VideoListFetchUseCase {
  VideoListFetchInteractor(
    this._searchRepository,
    this._watchHistoryRepository,
    this._blockListRepository,
  );

  final SearchRepository _searchRepository;
  final WatchHistoryRepository _watchHistoryRepository;
  final BlockListRepository _blockListRepository;

  @override
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request) async {
    final result = await this._searchRepository.search(request.keyword);

    final response = result.when(
      //  取得に成功した場合、オプションに応じてフィルタリングする。
      success: (result) async {
        final videoList =
            await this._convert(result.videos, request.options).toList();

        return VideoListFetchResponse.success(videoList, result.hasNextPage);
      },

      //  取得に失敗した場合、エラーとして返す。
      failure: (cause) async => VideoListFetchResponse.failure(cause),
    );

    return await response;
  }

//  動画リストの変換を掛ける。
  Stream<Video> _convert(List<VideoItem> list, FilteringOptions filter) async* {
    for (final item in list) {
      //  履歴データを取得する。
      final watchedAt =
          await this._watchHistoryRepository.getWatchedAt(item.videoId);
      final videoBlockedAt =
          await this._blockListRepository.getVideoBlockedAt(item.videoId);
      final channelBlockedAt =
          await this._blockListRepository.getChannelBlockedAt(item.channelId);

      //  Video型に変換する。
      final video = VideoConverter.convert(
        item,
        watchedAt,
        videoBlockedAt != null,
        channelBlockedAt != null,
      );

      //  フィルタリングを掛けて、対象のみ含めるようにする。
      if (filter.shouldInclude(video)) yield video;
    }
  }
}
