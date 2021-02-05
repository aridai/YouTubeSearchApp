# YouTubeSearchApp

https://github.com/aridai/YouTubeSearchApp

![CI](https://github.com/aridai/YouTubeSearchApp/workflows/CI/badge.svg)
![Dart](https://img.shields.io/static/v1?label=language&message=Dart&color=00B4AB)
![Flutter](https://img.shields.io/static/v1?label=framework&message=Flutter&color=46CAF9)

## 環境変数

プロジェクトルートに `.env` という名前で以下のファイルを配置

```
YOUTUBE_API_KEY=ここにYouTubeのAPIキーを配置
```

以下のコマンドで環境変数のコードを自動生成

```
flutter pub run build_runner build
```

## パッケージ構成

(プロジェクト規模が小さいため、技術駆動パッケージングを採用)

* `lib`: プロダクションコード
  * `application`: アプリケーション層 (ユースケースインタラクタなど)
  * `data`: データ層 (リポジトリやAPIサービスなど)
  * `env`: 環境変数
  * `model`: モデルの定義など
  * `ui`: UI層
* `test`: テストコード
