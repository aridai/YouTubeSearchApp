import 'dart:math';
import 'package:youtube_search_app/search/usecase/fetch/video_list_fetch_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/search/usecase/stub_repository.dart';
import 'package:youtube_search_app/video.dart';

class StubVideoListFetchInteractor implements VideoListFetchUseCase {
  StubVideoListFetchInteractor(this._repository);

  final StubRepository _repository;

  @override
  Future<VideoListFetchResponse> execute(VideoListFetchRequest request) async {
    await Future<void>.delayed(const Duration(seconds: 3));

    switch (Random().nextInt(10)) {
      case 1:
        return VideoListFetchResponseFailure(FetchErrorType.TokenError);

      case 2:
        return VideoListFetchResponseFailure(FetchErrorType.ClientError);

      case 3:
        return VideoListFetchResponseFailure(FetchErrorType.UnknownError);

      default:
        final list = this._createVideoList(request.keyword);
        const hasNextPage = true;

        this._repository.currentKeyword = request.keyword;
        this._repository.currentVideoList = list;

        return VideoListFetchResponseSuccess(list, hasNextPage);
    }
  }

  List<Video> _createVideoList(String keyword) {
    const destSize = 10;

    return List.generate(
      destSize,
      (i) {
        final n = i + 1;

        return Video(
          'VIDEO_ID_$n',
          'ダミー動画「$keyword」その$n',
          '動画説明',
          'https://placehold.jp/26/000000/FFFFFF/320x180.png?text=THUMBNAIL',
          DateTime(2021, 1, 1, 12, 0).add(Duration(minutes: n)),
          'CHANNEL_ID_$n',
          'チャンネル その$n',
        );
      },
    );
  }
}
