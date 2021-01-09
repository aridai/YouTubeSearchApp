import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:youtube_search_app/search/repository/search_result.dart';

part 'youtube_api_service.g.dart';

@RestApi(baseUrl: 'https://www.googleapis.com/youtube/v3/')
abstract class YouTubeApiService {
  factory YouTubeApiService(Dio dio, {String baseUrl}) = _YouTubeApiService;

  @GET('search')
  Future<SearchResult> search({
    @Query('part') String part = 'snippet',
    @Query('maxResults') int maxResults,
    @Query('order') String order = 'relevance',
    @Query('pageToken') String pageToken = null,
    @Query('q') String query,
    @Query('regionCode') String regionCode = 'JP',
    @Query('safeSearch') String safeSearch = 'none',
    @Query('type') String type = 'video',
    @Query('key') String key,
  });
}
