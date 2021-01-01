import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 16.0, 8.0),
        child: Card(
          elevation: 3.0,
          child: InkWell(
            child: this._buildCardContents(),
            onTap: () => this._onTap(),
            onLongPress: () => this._onLongPress(),
          ),
        ),
      );

  //  Card内のコンテンツを生成する。
  Widget _buildCardContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          this._buildVideoThumbnail(),
          this._buildVideoTitle(),
          this._buildChannelTitle(),
          this._buildUploadedAt(),
        ],
      );

  //  動画のサムネイルを生成する。
  Widget _buildVideoThumbnail() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: AspectRatio(
            aspectRatio: _thumbnailAspectRatio,
            child: Image.network(
              this.model.thumbnailUrl,
              fit: BoxFit.fill,
              isAntiAlias: true,
            ),
          ),
        ),
      );

  //  動画のタイトルを生成する。
  Widget _buildVideoTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        child: Text(
          this.model.title,
          style: const TextStyle(color: Colors.black),
        ),
      );

  //  チャンネル名を生成する。
  Widget _buildChannelTitle() => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        child: Text(
          this.model.channelTitle,
          style: const TextStyle(color: Colors.black87),
        ),
      );

  //  動画の投稿日時を生成する。
  Widget _buildUploadedAt() => Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
        child: Text(
          _formatter.format(this.model.uploadedAt),
          style: const TextStyle(color: Colors.black87),
        ),
      );

  //  この動画要素がタップされたとき。
  void _onTap() {}

  //  この動画要素が長押しされたとき。
  void _onLongPress() {}
}
