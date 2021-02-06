import 'package:youtube_search_app/application/search/reload/video_list_reload_use_case.dart';

class VideoListReloadInteractor implements VideoListReloadUseCase {
  @override
  Future<VideoListReloadResponse> execute(
      VideoListReloadRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));

    return VideoListReloadResponse(List.empty(), false);
  }
}
