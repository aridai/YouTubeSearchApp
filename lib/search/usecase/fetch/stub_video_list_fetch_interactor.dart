import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/search/usecase/stub_repository.dart';
import 'package:youtube_search_app/video.dart';

class StubVideoListFetchInteractor implements VideoListFetchUseCase {
  StubVideoListFetchInteractor(this._repository);

  final StubRepository _repository;

  @override
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request) async {
    await Future<void>.delayed(const Duration(seconds: 3));

    const destSize = 10;
    final newList = List.generate(
      destSize,
      (i) {
        final n = i + 1;

        return Video(
          'VIDEO_ID_$n',
          'ダミー動画「${request.keyword}」その$n',
          '動画説明',
          'https://placehold.jp/26/000000/FFFFFF/320x180.png?text=THUMBNAIL',
          DateTime(2021, 1, 1, 12, 0).add(Duration(minutes: n)),
          'CHANNEL_ID_$n',
          'チャンネル その$n',
        );
      },
    );
    const hasNextPage = true;

    this._repository.currentKeyword = request.keyword;
    this._repository.currentVideoList = newList;

    return VideoListFetchResponseSuccess(newList, hasNextPage);
  }
}
