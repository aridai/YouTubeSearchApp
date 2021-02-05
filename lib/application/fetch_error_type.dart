//  動画リストの取得エラーの種類
enum FetchErrorType {
  //  トークンエラー
  //  (YouTubeのAPIのリクエスト制限など)
  TokenError,

  //  クライアントエラー
  //  (オフライン状態など)
  ClientError,

  //  その他不明のエラー
  UnknownError,
}
