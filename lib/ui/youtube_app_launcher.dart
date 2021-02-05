import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' show window;
import 'package:url_launcher/url_launcher.dart';

abstract class YouTubeAppLauncher {
  static YouTubeAppLauncher _instance = null;

  //  シングルトンインスタンス
  static YouTubeAppLauncher get instance {
    _instance ??= _YouTubeAppLauncher();

    return _instance;
  }

  //  指定した動画をYouTube公式アプリで開く。
  Future<void> launchYouTubeApp(String videoId);
}

class _YouTubeAppLauncher extends YouTubeAppLauncher {
  //  iOSのプラットフォーム文字列のリスト
  static const _iOSPlatforms = ['iPhone', 'iPod', 'iPad'];

  //  iOSのPWAアプリとして動作しているかどうか
  //  (判定結果をキャッシュしておく。)
  bool _isPWAiOS = null;

  @override
  Future<void> launchYouTubeApp(String videoId) async {
    this._isPWAiOS ??= kIsWeb &&
        _iOSPlatforms.any((p) => window.navigator.platform.contains(p));

    final uri = this._isPWAiOS
        ? 'youtube://$videoId'
        : 'https://www.youtube.com/watch?v=$videoId';

    await launch(uri, forceSafariVC: false, webOnlyWindowName: '_blank');
  }
}
