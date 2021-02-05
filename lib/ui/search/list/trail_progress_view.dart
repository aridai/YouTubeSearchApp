import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_search_app/ui/search/search_page_bloc.dart';

//  検索ページのリストの末尾要素
//  リストを末尾までスクロールしたときに自動で追加取得を行うときのView
class TrailProgressView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: VisibilityDetector(
        key: const Key('IndicatorKey'),
        child: const Center(child: CircularProgressIndicator()),
        onVisibilityChanged: (info) => this._onVisibilityChanged(info, bloc),
      ),
    );
  }

  //  ProgressIndicatorの可視性が変化したとき。
  Future<void> _onVisibilityChanged(
      VisibilityInfo info, SearchPageBloc bloc) async {
    if (info.visibleFraction > 0.0) await bloc.fetchAdditionally();
  }
}
