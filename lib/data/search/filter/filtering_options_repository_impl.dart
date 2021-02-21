import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_search_app/application/search/filter/filtering_options_repository.dart';
import 'package:youtube_search_app/model/filtering_options.dart';
import 'package:youtube_search_app/data/search/filter/filtering_options_parser.dart';

class FilteringOptionsRepositoryImpl implements FilteringOptionsRepository {
  FilteringOptionsRepositoryImpl(this._preferences);

  static const String _key = 'KEY_FILTERING_OPTIONS';
  final SharedPreferences _preferences;

  @override
  FilteringOptions getOptions() {
    final json = this._preferences.getString(_key);
    if (json == null) return FilteringOptions.initial();

    return FilteringOptionsParser.fromJson(json);
  }

  @override
  Future<void> saveOptions(FilteringOptions options) async {
    final json = FilteringOptionsParser.toJson(options);
    await this._preferences.setString(_key, json);
  }
}
