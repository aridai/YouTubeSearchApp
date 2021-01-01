import 'package:flutter/material.dart';
import 'package:youtube_search_app/search/trail_progress_view.dart';
import 'package:youtube_search_app/search/video_view.dart';

//  検索ページのリスト
class SearchPageList extends StatelessWidget {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) => this._buildList();

  //  リストを生成する。
  Widget _buildList() => RefreshIndicator(
        child: Scrollbar(
          controller: this._controller,
          child: ListView.builder(
            controller: this._controller,
            itemCount: 30,
            itemBuilder: this._buildListElement,
          ),
        ),
        onRefresh: () => this._onRefresh(),
      );

  //  リスト要素を生成する。
  Widget _buildListElement(BuildContext context, int index) =>
      index != 29 ? VideoView(index, null) : TrailProgressView();

  //  スワイプ更新が掛けられたとき。
  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}
