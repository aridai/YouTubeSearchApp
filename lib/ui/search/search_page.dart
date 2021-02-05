import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_search_app/application/fetch_error_type.dart';
import 'package:youtube_search_app/dependency.dart';
import 'package:youtube_search_app/ui/filter/dialog/filter_dialog.dart';
import 'package:youtube_search_app/ui/search/list/search_page_list.dart';
import 'package:youtube_search_app/ui/search/search_keyword_field.dart';
import 'package:youtube_search_app/ui/search/search_page_bloc.dart';
import 'package:youtube_search_app/ui/search/search_page_drawer.dart';
import 'package:youtube_search_app/ui/youtube_app_launcher.dart';

//  検索ページ
class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<SearchPageBloc>(
        create: (context) => Dependency.resolve(),
        dispose: (context, bloc) => bloc.dispose(),
        child: _SearchPageContent(),
      );
}

//  検索ページのコンテンツ
class _SearchPageContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<_SearchPageContent> {
  final _compositeSubscription = CompositeSubscription();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<SearchPageBloc>(context);

    bloc.errorStream.listen(this._onError).addTo(this._compositeSubscription);
    bloc.videoIdToWatchStream
        .listen(this._launchYouTubeApp)
        .addTo(this._compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return Scaffold(
      appBar: this._buildAppBar(),
      drawer: SearchPageDrawer(),
      body: this._buildBody(context, bloc),
    );
  }

  @override
  void dispose() {
    this._compositeSubscription.dispose();
    super.dispose();
  }

  //  アプリバーを生成する。
  PreferredSizeWidget _buildAppBar() => AppBar(
        title: SearchKeywordField(),
        actions: [this._buildFilterIcon()],
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
  Future<void> _onFilterIconPressed() async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => FilterDialog(),
    );

    if (shouldUpdate == true) {
      //  TODO: 更新
    }
  }

  //  キーボードを非表示にする。
  void _dismissKeyboard(BuildContext context) {
    final currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  //  エラーが発生したとき。
  void _onError(FetchErrorType error) {
    String message;
    switch (error) {
      case FetchErrorType.TokenError:
        message = '時間をおいてからリトライしてください。';
        break;
      case FetchErrorType.ClientError:
        message = 'インターネット環境を確認してリトライしてください。';
        break;
      case FetchErrorType.UnknownError:
        message = 'エラーが発生しました。時間をおいてからリトライしてください。';
        break;
    }

    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
  }

  //  YouTubeアプリを開いて動画の視聴を開始する。
  Future<void> _launchYouTubeApp(String videoId) async {
    await YouTubeAppLauncher.instance.launchYouTubeApp(videoId);
  }
}
