import 'dart:math';
import 'package:youtube_search_app/search/usecase/append/video_list_append_use_case.dart';
import 'package:youtube_search_app/search/usecase/fetch_error_type.dart';
import 'package:youtube_search_app/search/usecase/stub_repository.dart';
import 'package:youtube_search_app/video.dart';

class StubVideoListAppendInteractor implements VideoListAppendUseCase {
  StubVideoListAppendInteractor(this._repository);

  final StubRepository _repository;

  @override
  Future<VideoListAppendResponse> execute(
      VideoListAppendRequest request) async {
    await Future<void>.delayed(const Duration(seconds: 3));

    switch (Random().nextInt(10)) {
      case 1:
        return VideoListAppendResponseFailure(FetchErrorType.TokenError);

      case 2:
        return VideoListAppendResponseFailure(FetchErrorType.ClientError);

      case 3:
        return VideoListAppendResponseFailure(FetchErrorType.UnknownError);

      default:
        final keyword = this._repository.currentKeyword;
        final currentSize = this._repository.currentVideoList.length;
        final destSize = currentSize + 5;

        final list = this._createVideoList(destSize, keyword);
        final hasNextPage = destSize < 25;

        this._repository.currentVideoList = list;

        return VideoListAppendResponseSuccess(list, hasNextPage);
    }
  }

  List<Video> _createVideoList(int destSize, String keyword) => List.generate(
        destSize,
        (i) {
          final n = i + 1;

          return Video(
            'VIDEO_ID_$n',
            'ダミー動画「${this._repository.currentKeyword}」その$n',
            '動画説明',
            'https://placehold.jp/26/000000/FFFFFF/320x180.png?text=THUMBNAIL',
            DateTime(2021, 1, 1, 12, 0).add(Duration(minutes: n)),
            'CHANNEL_ID_$n',
            'チャンネル その$n',
          );
        },
      );
}
