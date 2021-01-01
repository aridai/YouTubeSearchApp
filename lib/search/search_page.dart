import 'dart:math';

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
  Widget build(BuildContext context) => Scaffold(
        appBar: this._buildAppBar(context),
        drawer: SearchPageDrawer(),
        body: this._buildBody(context),
      );

  //  アプリバーを生成する。
  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
        title: this._buildKeywordField(context),
        actions: [this._buildFilterIcon()],
      );

  //  キーワードフィールドを生成する。
  Widget _buildKeywordField(BuildContext context) => TextField(
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
        onEditingComplete: () => this._onKeywordEditingCompleted(context),
      );

  //  フィルタアイコンを生成する。
  Widget _buildFilterIcon() => IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () => this._onFilterIconPressed(),
      );

  //  ボディを生成する。
  Widget _buildBody(BuildContext context) => GestureDetector(
        //  本来はリストの有無によって分岐するが、現段階では仮にこうしておく。
        child:
            Random().nextBool() ? SearchPageList() : this._buildGuideMessage(),
        onTap: () => this._dismissKeyboard(context),
      );

  //  ガイドメッセージを生成する。
  //  GestureDetectorのタッチ判定範囲を広げるため、透明の背景を追加している。
  Widget _buildGuideMessage() => Container(
        color: Colors.transparent,
        child: const Center(child: Text('検索キーワードを入力してください。')),
      );

  //  フィルタアイコンが押されたとき。
  void _onFilterIconPressed() {}

  //  キーワードの編集が完了したとき。
  void _onKeywordEditingCompleted(BuildContext context) {
    this._dismissKeyboard(context);
  }

  //  キーボードを非表示にする。
  void _dismissKeyboard(BuildContext context) {
    final currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
}
