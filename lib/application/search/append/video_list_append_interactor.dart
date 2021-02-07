import 'package:youtube_search_app/application/block/block_list_repository.dart';
import 'package:youtube_search_app/application/history/watch/watch_history_repository.dart';
import 'package:youtube_search_app/application/search/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/application/search/search_repository.dart';
import 'package:youtube_search_app/application/search/search_result.dart';
import 'package:youtube_search_app/application/search/video_converter.dart';
import 'package:youtube_search_app/model/video.dart';
import 'package:youtube_search_app/model/video_item.dart';

class VideoListAppendInteractor implements VideoListAppendUseCase {
  VideoListAppendInteractor(
    this._searchRepository,
    this._watchHistoryRepository,
    this._blockListRepository,
  );

  final SearchRepository _searchRepository;
  final WatchHistoryRepository _watchHistoryRepository;
  final BlockListRepository _blockListRepository;

  @override
  Future<VideoListAppendResponse> execute(
      VideoListAppendRequest request) async {
    final result = await this._searchRepository.searchAdditionally();

    final response = result.when(
      //  取得に成功した場合、フィルタリングして返す。
      success: (result) async {
        //  TODO: フィルタリング処理
        final videoList = await Future.wait(
          result.videos.map((item) async => this.toVideo(item)),
        );

        return VideoListAppendResponse.success(videoList, result.hasNextPage);
      },

      //  取得に失敗した場合、エラーを返す。
      failure: (cause) async => VideoListAppendResponse.failure(cause),
    );

    return await response;
  }

  Future<Video> toVideo(VideoItem item) async {
    final watchedAt =
        await this._watchHistoryRepository.getWatchedAt(item.videoId);
    final videoBlockedAt =
        await this._blockListRepository.getVideoBlockedAt(item.videoId);
    final channelBlockedAt =
        await this._blockListRepository.getChannelBlockedAt(item.channelId);

    return VideoConverter.convert(
      item,
      watchedAt,
      videoBlockedAt != null,
      channelBlockedAt != null,
    );
  }
}
