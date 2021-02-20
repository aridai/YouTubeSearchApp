import 'package:test/test.dart';
import 'package:youtube_search_app/model/dummy_video.dart';
import 'package:youtube_search_app/model/filtering_options.dart';

void main() {
  group('フィルタリングオプションのテスト', () {
    final video = DummyVideo.create();
    final videos = [
      video.copyWith(
        title: '動画1',
        watchedAt: null,
        isBlockedVideo: false,
        isBlockedChannel: false,
      ),
      video.copyWith(
        title: '動画2',
        watchedAt: DateTime.now(),
        isBlockedVideo: false,
        isBlockedChannel: false,
      ),
      video.copyWith(
        title: '動画3',
        watchedAt: DateTime.now(),
        isBlockedVideo: true,
        isBlockedChannel: false,
      ),
      video.copyWith(
        title: '動画4',
        watchedAt: null,
        isBlockedVideo: false,
        isBlockedChannel: true,
      ),
      video.copyWith(
        title: '動画5',
        watchedAt: DateTime.now(),
        isBlockedVideo: true,
        isBlockedChannel: true,
      ),
    ];

    test('すべてを含めるケースのテスト', () {
      const options = FilteringOptions(true, true, true, RegexFiltering.none());

      final expected = [true, true, true, true, true];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('視聴済み動画のテスト', () {
      //  視聴済み動画を含めない設定
      const options =
          FilteringOptions(false, true, true, RegexFiltering.none());

      final expected = [true, false, false, true, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('ブロック済み動画のテスト', () {
      //  ブロック済み動画を含めない設定
      const options =
          FilteringOptions(true, false, true, RegexFiltering.none());

      final expected = [true, true, false, true, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('ブロック済みチャンネルのテスト', () {
      //  ブロック済みチャンネルを含めない設定
      const options =
          FilteringOptions(true, true, false, RegexFiltering.none());

      final expected = [true, true, true, false, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('ホワイトリスト方式正規表現フィルタのテスト', () {
      //  タイトルに「2」か「3」が含まれる動画のみを含める設定
      const options = FilteringOptions(
        true,
        true,
        true,
        RegexFiltering.white('(.*)[2-3](.*)'),
      );

      final expected = [false, true, true, false, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('ブラックリスト方式正規表現フィルタのテスト', () {
      //  タイトルに「1」か「2」か「3」が含まれない動画のみを含める設定
      const options = FilteringOptions(
        true,
        true,
        true,
        RegexFiltering.black('(.*)[1-3](.*)'),
      );

      final expected = [false, false, false, true, true];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('視聴済み動画とブロック済み動画の組み合わせのテスト', () {
      //  視聴済み動画とブロック済み動画を含めない設定
      const options =
          FilteringOptions(false, false, true, RegexFiltering.none());

      final expected = [true, false, false, true, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('視聴済み動画とブロック済みチャンネルの組み合わせのテスト', () {
      //  視聴済み動画とブロック済みチャンネルを含めない設定
      const options =
          FilteringOptions(false, true, false, RegexFiltering.none());

      final expected = [true, false, false, false, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('ブロック済み動画とブロック済みチャンネルの組み合わせのテスト', () {
      //  ブロック済み動画とブロック済みチャンネルを含めない設定
      const options =
          FilteringOptions(true, false, false, RegexFiltering.none());

      final expected = [true, true, false, false, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });

    test('視聴済み動画と正規表現フィルタのテスト', () {
      //  視聴済み動画とタイトルに「1」から「3」を含めない設定
      const options = FilteringOptions(
        false,
        true,
        true,
        RegexFiltering.black('(.*)[1-3](.*)'),
      );

      final expected = [false, false, false, true, false];
      final actual = videos.map(options.shouldInclude);

      expect(actual, orderedEquals(expected));
    });
  });
}
