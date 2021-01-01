import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

//  検索ページのリストの末尾要素
//  リストを末尾までスクロールしたときに自動で追加取得を行うときのView
class TrailProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: VisibilityDetector(
          key: const Key('IndicatorKey'),
          child: const Center(child: CircularProgressIndicator()),
          onVisibilityChanged: (info) => this._onVisibilityChanged(info),
        ),
      );

  //  ProgressIndicatorの可視性が変化したとき。
  void _onVisibilityChanged(VisibilityInfo info) {}
}
