import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youtube_search_app/search/search_page_bloc.dart';
import 'package:youtube_search_app/video.dart';

//  検索ページのリストの動画の要素
class VideoView extends StatelessWidget {
  const VideoView(this.index, this.model);

  //  サムネイル画像のアスペクト比
  static const _thumbnailAspectRatio = 320.0 / 180.0;

  //  日時のフォーマット
  static final _formatter = DateFormat('yyyy/MM/dd HH:mm');

  final int index;
  final Video model;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 8.0),
      child: Card(
        elevation: 3.0,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: this._buildCardContents(),
          ),
          onTap: () => this._onTap(bloc),
          onLongPress: () => this._onLongPress(),
        ),
      ),
    );
  }

  //  Card内のコンテンツを生成する。
  Widget _buildCardContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          this._buildVideoThumbnail(),
          this._buildVideoTitle(),
          this._buildChannelTitle(),
          this._buildUploadedAt(),
          this._buildWatchedAt(),
          this._buildBlockedVideoIcon(),
          this._buildBlockedChannelIcon(),
        ],
      );

  //  動画のサムネイルを生成する。
  Widget _buildVideoThumbnail() => Container(
        child: AspectRatio(
          aspectRatio: _thumbnailAspectRatio,
          child: Image.network(
            this.model.thumbnailUrl,
            fit: BoxFit.fill,
            isAntiAlias: true,
          ),
        ),
      );

  //  動画のタイトルを生成する。
  Widget _buildVideoTitle() => Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Text(
          this.model.title,
          style: const TextStyle(color: Colors.black),
        ),
      );

  //  チャンネル名を生成する。
  Widget _buildChannelTitle() => Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Text(
          this.model.channelTitle,
          style: const TextStyle(color: Colors.black87),
        ),
      );

  //  動画の投稿日時を生成する。
  Widget _buildUploadedAt() => Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: Text(
          _formatter.format(this.model.uploadedAt),
          style: const TextStyle(color: Colors.black87),
        ),
      );

  //  動画の視聴日時を生成する。
  Widget _buildWatchedAt() {
    if (this.model.watchedAt == null) return Container();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(Icons.remove_red_eye, size: 20.0, color: Colors.green),
        ),
        Text('視聴済み (${_formatter.format(this.model.watchedAt)})'),
      ],
    );
  }

  //  ブロックされた動画のアイコンを生成する。
  Widget _buildBlockedVideoIcon() {
    if (!this.model.isBlockedVideo) return Container();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(Icons.block, size: 20.0, color: Colors.red),
        ),
        Text('ブロック済み動画')
      ],
    );
  }

  //  ブロックされたチャンネルのアイコンを生成する。
  Widget _buildBlockedChannelIcon() {
    if (!this.model.isBlockedChannel) return Container();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(Icons.block, size: 20.0, color: Colors.purple),
        ),
        Text('ブロック済みチャンネル')
      ],
    );
  }

  //  この動画要素がタップされたとき。
  Future<void> _onTap(SearchPageBloc bloc) async {
    await bloc.onVideoClicked(this.model);
  }

  //  この動画要素が長押しされたとき。
  void _onLongPress() {}
}
