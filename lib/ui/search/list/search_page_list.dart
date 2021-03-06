import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_search_app/ui/search/list/list_element.dart';
import 'package:youtube_search_app/ui/search/list/trail_progress_view.dart';
import 'package:youtube_search_app/ui/search/list/video_view.dart';
import 'package:youtube_search_app/ui/search/search_page_bloc.dart';

//  検索ページのリスト
class SearchPageList extends StatelessWidget {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return this._buildRefreshIndicator(bloc);
  }

  //  RefreshIndicatorを生成する。
  Widget _buildRefreshIndicator(SearchPageBloc bloc) => RefreshIndicator(
        child: Scrollbar(
          controller: this._controller,
          child: this._buildList(bloc),
        ),
        onRefresh: () => this._onRefresh(bloc),
      );

  //  リストを生成する。
  Widget _buildList(SearchPageBloc bloc) => StreamBuilder<List<ListElement>>(
        initialData: List.empty(),
        stream: bloc.list,
        builder: (context, snapshot) => ListView.builder(
          controller: this._controller,
          itemCount: snapshot.data.length,
          itemBuilder: (_, i) => this._buildListElement(i, snapshot.data[i]),
        ),
      );

  //  リスト要素を生成する。
  Widget _buildListElement(int index, ListElement element) => element.when(
        video: (video) => VideoView(index, video),
        indicator: () => TrailProgressView(),
      );

  //  スワイプ更新が掛けられたとき。
  Future<void> _onRefresh(SearchPageBloc bloc) async {
    await bloc.refresh();
  }
}
