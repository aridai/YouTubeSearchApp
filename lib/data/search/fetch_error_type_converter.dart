import 'dart:io';

import 'package:dio/dio.dart';
import 'package:youtube_search_app/application/fetch_error_type.dart';

//  FetchErrorTypeのコンバータ
abstract class FetchErrorTypeConverter {
  //  例外をFetchErrorTypeに変換する。
  static FetchErrorType convert(Exception e) {
    if (e is DioError) {
      print('DIOエラー: $e');

      switch (e.type) {
        //  トークンまわりのエラー
        case DioErrorType.RESPONSE:
          return FetchErrorType.TokenError;

        //  タイムアウト系はGoogleのサーバが遅いことはあまり考えられないため、
        //  クライアント側のエラーとみなしてしまう。
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
          return FetchErrorType.ClientError;

        //  オフライン環境で実行するとSocketExceptionが投げられる。
        case DioErrorType.DEFAULT:
          return e.response is SocketException
              ? FetchErrorType.ClientError
              : FetchErrorType.UnknownError;

        default:
          return FetchErrorType.UnknownError;
      }
    } else {
      print('エラー: $e');
      return FetchErrorType.UnknownError;
    }
  }
}
