import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youtube_search_app/model/filtering_options.dart';

part 'filtering_options_parser.freezed.dart';

part 'filtering_options_parser.g.dart';

//  FilteringOptionsのパーサ
abstract class FilteringOptionsParser {
  //  JSON文字列に変換する。
  static String toJson(FilteringOptions options) {
    final regex = options.regexFiltering.when(
      none: () => _RegexFilteringData('none', null),
      white: (pattern) => _RegexFilteringData('white', pattern),
      black: (pattern) => _RegexFilteringData('black', pattern),
    );

    final serializable = _SerializableFilteringOptions(
      options.includesWatchedVideos,
      options.includesBlockedVideos,
      options.includesBlockedChannels,
      regex.type,
      regex.pattern,
    );
    final json = serializable.toJson();

    return jsonEncode(json);
  }

  //  JSON文字列から変換する。
  static FilteringOptions fromJson(String json) {
    final jsonMap = jsonDecode(json) as Map<String, dynamic>;
    final serializable = _SerializableFilteringOptions.fromJson(jsonMap);

    RegexFiltering regexFiltering;
    switch (serializable.regexFilteringType) {
      case 'none':
        regexFiltering = const RegexFiltering.none();
        break;

      case 'white':
        regexFiltering =
            RegexFiltering.white(serializable.regexFilteringPattern);
        break;

      case 'black':
        regexFiltering =
            RegexFiltering.black(serializable.regexFilteringPattern);
        break;

      default:
        throw StateError('フィルタリングオプションのJSONが不正です。');
    }

    return FilteringOptions(
      serializable.includesWatchedVideos,
      serializable.includesBlockedVideos,
      serializable.includesBlockedChannels,
      regexFiltering,
    );
  }
}

@freezed
abstract class _SerializableFilteringOptions
    with _$_SerializableFilteringOptions {
  const factory _SerializableFilteringOptions(
    bool includesWatchedVideos,
    bool includesBlockedVideos,
    bool includesBlockedChannels,
    String regexFilteringType,
    @nullable String regexFilteringPattern,
  ) = __SerializableFilteringOptions;

  factory _SerializableFilteringOptions.fromJson(Map<String, dynamic> json) =>
      _$_SerializableFilteringOptionsFromJson(json);
}

class _RegexFilteringData {
  _RegexFilteringData(this.type, this.pattern);

  final String type;
  final String pattern;
}
