import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_search_app/search/search_page_bloc.dart';

//  検索キーワードの入力フィールド
class SearchKeywordField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchKeywordFieldState();
}

class _SearchKeywordFieldState extends State<SearchKeywordField> {
  TextEditingController _controller = null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchPageBloc>(context);

    return StreamBuilder<String>(
      initialData: '',
      stream: bloc.keyword,
      builder: (context, snapshot) {
        this._controller.value =
            this._controller.value.copyWith(text: snapshot.data);

        return this._buildTextField(bloc);
      },
    );
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  Widget _buildTextField(SearchPageBloc bloc) => TextField(
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
        onChanged: (keyword) => bloc.keywordSink.add(keyword),
        onEditingComplete: () => this._onKeywordEditingCompleted(context, bloc),
      );

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
