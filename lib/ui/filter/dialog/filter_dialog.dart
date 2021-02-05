import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_search_app/dependency.dart';
import 'package:youtube_search_app/ui/filter/dialog/filter_dialog_bloc.dart';
import 'package:youtube_search_app/ui/filter/regex/regex_field.dart';
import 'package:youtube_search_app/ui/filter/regex/regex_filter_type.dart';

//  フィルタダイアログ
//  (結果として更新が必要かどうかを表すbool値を返す。)
class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<FilterDialogBloc>(
      create: (context) => Dependency.resolve(),
      dispose: (context, bloc) => bloc.dispose(),
      child: _FilterDialog(),
    );
  }
}

class _FilterDialog extends StatelessWidget {
  static const _regexFilterPopupMenuItems = [
    PopupMenuItem(value: RegexFilterType.NONE, child: Text('なし')),
    PopupMenuItem(value: RegexFilterType.WHITE_LIST, child: Text('ホワイトリスト')),
    PopupMenuItem(value: RegexFilterType.BLACK_LIST, child: Text('ブラックリスト')),
  ];

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FilterDialogBloc>(context);

    return this._buildAlertDialog(context, bloc);
  }

  //  アラートダイアログを生成する。
  Widget _buildAlertDialog(BuildContext context, FilterDialogBloc bloc) =>
      AlertDialog(
        title: const Text('検索フィルタ'),
        content: this._buildContent(bloc),
        actions: [
          this._buildCancelButton(context),
          this._buildOKButton(context, bloc),
        ],
        scrollable: true,
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.all(16),
        buttonPadding: const EdgeInsets.all(4),
        insetPadding: const EdgeInsets.all(8),
      );

  //  コンテンツを生成する。
  Widget _buildContent(FilterDialogBloc bloc) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          this._buildWatchedVideoItem(bloc),
          this._buildBlockedVideoItem(bloc),
          this._buildBlockedChannelItem(bloc),
          this._buildRegexItem(bloc),
          this._buildRegexField(bloc),
        ],
      );

  //  視聴済み動画の項目を生成する。
  Widget _buildWatchedVideoItem(FilterDialogBloc bloc) => StreamBuilder<bool>(
      stream: bloc.includesWatchedVideos,
      initialData: true,
      builder: (context, snapshot) {
        final includes = snapshot.data;

        return SwitchListTile(
          title: const Text('視聴済み動画'),
          subtitle: Text('視聴済みの動画を表示${includes ? 'します。' : 'しません。'}'),
          value: includes,
          contentPadding: const EdgeInsets.all(0),
          onChanged: bloc.onWatchedVideoFilterChanged,
        );
      });

  //  ブロック動画の項目を生成する。
  Widget _buildBlockedVideoItem(FilterDialogBloc bloc) => StreamBuilder<bool>(
      stream: bloc.includesBlockedVideos,
      initialData: false,
      builder: (context, snapshot) {
        final includes = snapshot.data;

        return SwitchListTile(
          title: const Text('ブロック動画'),
          subtitle: Text('ブロックした動画を表示${includes ? 'します。' : 'しません。'}'),
          value: includes,
          contentPadding: const EdgeInsets.all(0),
          onChanged: bloc.onBlockedVideoFilterChanged,
        );
      });

  //  ブロックチャンネルの項目を生成する。
  Widget _buildBlockedChannelItem(FilterDialogBloc bloc) => StreamBuilder<bool>(
      stream: bloc.includesBlockedChannels,
      initialData: false,
      builder: (context, snapshot) {
        final includes = snapshot.data;

        return SwitchListTile(
          title: const Text('ブロックチャンネル'),
          subtitle: Text('ブロックしたチャンネルの動画を表示${includes ? 'します。' : 'しません。'}'),
          value: includes,
          contentPadding: const EdgeInsets.all(0),
          onChanged: bloc.onBlockedChannelFilterChanged,
        );
      });

  //  正規表現フィルタの項目を生成する。
  Widget _buildRegexItem(FilterDialogBloc bloc) => ListTile(
        title: StreamBuilder<RegexFilterType>(
          stream: bloc.regexFilterType,
          initialData: RegexFilterType.NONE,
          builder: (context, snapshot) => snapshot.data.when(
            none: () => const Text('正規表現フィルタ (なし)'),
            white: () => const Text('正規表現フィルタ (ホワイトリスト)'),
            black: () => const Text('正規表現フィルタ (ブラックリスト)'),
          ),
        ),
        subtitle: StreamBuilder<RegexFilterType>(
          stream: bloc.regexFilterType,
          initialData: RegexFilterType.NONE,
          builder: (context, snapshot) => snapshot.data.when(
            none: () => const Text('タイトルによるフィルタリングを行いません。'),
            white: () => const Text('タイトルが正規表現にマッチする動画のみを表示します。'),
            black: () => const Text('タイトルが正規表現にマッチしない動画のみを表示します。'),
          ),
        ),
        trailing: PopupMenuButton<RegexFilterType>(
          icon: const Icon(Icons.arrow_drop_down, size: 32),
          itemBuilder: (context) => _regexFilterPopupMenuItems,
          onSelected: bloc.onRegexFilterTypeChanged,
        ),
        contentPadding: const EdgeInsets.all(0),
      );

  //  正規表現フィルタの入力フィールドを生成する。
  Widget _buildRegexField(FilterDialogBloc bloc) =>
      StreamBuilder<RegexFilterType>(
        stream: bloc.regexFilterType,
        initialData: RegexFilterType.NONE,
        builder: (context, snapshot) =>
            snapshot.data == RegexFilterType.NONE ? Container() : RegexField(),
      );

  //  OKボタンを生成する。
  Widget _buildOKButton(BuildContext context, FilterDialogBloc bloc) =>
      StreamBuilder<bool>(
        stream: bloc.isOKButtonEnabled,
        initialData: false,
        builder: (context, snapshot) {
          final isEnabled = snapshot.data;
          final eventListener =
              isEnabled ? () => this._onOKButtonClicked(context, bloc) : null;

          return FlatButton(
            child: const Text('OK'),
            onPressed: eventListener,
          );
        },
      );

  //  キャンセルボタンを生成する。
  Widget _buildCancelButton(BuildContext context) => FlatButton(
        child: const Text('キャンセル'),
        onPressed: () => Navigator.pop(context, false),
      );

  //  OKボタンがクリックされたとき。
  void _onOKButtonClicked(BuildContext context, FilterDialogBloc bloc) {
    bloc.onOKButtonClicked();
    Navigator.pop(context, true);
  }
}
