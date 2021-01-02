import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_search_app/search/search_page_bloc.dart';
import 'package:youtube_search_app/search/search_page_drawer.dart';
import 'package:youtube_search_app/search/search_page_list.dart';

//  検索ページ
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<SearchPageBloc>(
        create: (context) => SearchPageBloc(),
        dispose: (context, bloc) => bloc.dispose(),
        child: _SearchPageContent(),
      );
}

//  検索ページのコンテンツ
class _SearchPageContent extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return Scaffold(
      appBar: this._buildAppBar(context, bloc),
      drawer: SearchPageDrawer(),
      body: this._buildBody(context, bloc),
    );
  }

  //  アプリバーを生成する。
  PreferredSizeWidget _buildAppBar(BuildContext context, SearchPageBloc bloc) =>
      AppBar(
        title: this._buildKeywordField(context, bloc),
        actions: [this._buildFilterIcon()],
      );

  //  キーワードフィールドを生成する。
  Widget _buildKeywordField(BuildContext context, SearchPageBloc bloc) =>
      TextField(
        controller: this._controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '検索キーワード',
          hintStyle: TextStyle(color: Colors.white),
        ),
        onEditingComplete: () => this._onKeywordEditingCompleted(context, bloc),
      );

  //  フィルタアイコンを生成する。
  Widget _buildFilterIcon() => IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () => this._onFilterIconPressed(),
      );

  //  ボディを生成する。
  Widget _buildBody(BuildContext context, SearchPageBloc bloc) =>
      GestureDetector(
        child: this._buildRefreshIndicator(bloc),
        onTap: () => this._dismissKeyboard(context),
      );

  //  RefreshIndicatorを生成する。
  Widget _buildRefreshIndicator(SearchPageBloc bloc) => StreamBuilder<bool>(
        initialData: false,
        stream: bloc.isProgressIndicatorVisible,
        builder: (context, snapshot) {
          final isRefreshing = snapshot.data;

          if (isRefreshing) {
            return this._buildProgressIndicator();
          } else {
            return this._buildSearchPageList(bloc);
          }
        },
      );

  //  検索ページのリストを生成する。
  Widget _buildSearchPageList(SearchPageBloc bloc) => StreamBuilder<bool>(
        initialData: false,
        stream: bloc.isNotEmpty,
        builder: (context, snapshot) {
          final isNotEmpty = snapshot.data;

          return isNotEmpty ? SearchPageList() : this._buildGuideMessage();
        },
      );

  //  ガイドメッセージを生成する。
  //  GestureDetectorのタッチ判定範囲を広げるため、透明の背景を追加している。
  Widget _buildGuideMessage() => Container(
        color: Colors.transparent,
        child: const Center(child: Text('検索キーワードを入力してください。')),
      );

  //  ProgressIndicatorを生成する。
  Widget _buildProgressIndicator() =>
      const Center(child: CircularProgressIndicator());

  //  フィルタアイコンが押されたとき。
  void _onFilterIconPressed() {}

  //  キーワードの編集が完了したとき。
  Future<void> _onKeywordEditingCompleted(
      BuildContext context, SearchPageBloc bloc) async {
    this._dismissKeyboard(context);
    await bloc.search();
  }

  //  キーボードを非表示にする。
  void _dismissKeyboard(BuildContext context) {
    final currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
