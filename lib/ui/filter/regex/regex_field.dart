import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_search_app/ui/filter/dialog/filter_dialog_bloc.dart';

//  正規表現入力フィールド
class RegexField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegexFieldState();
}

class _RegexFieldState extends State<RegexField> {
  TextEditingController _controller = null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FilterDialogBloc>(context);

    TextEditingController().dispose();
    ScrollController().dispose();

    return StreamBuilder<String>(
      stream: bloc.regexFilterPatternString,
      initialData: '',
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

  //  入力フィールドを生成する。
  Widget _buildTextField(FilterDialogBloc bloc) => StreamBuilder<bool>(
      stream: bloc.isValidRegexFieldState,
      initialData: false,
      builder: (context, snapshot) {
        final isValid = snapshot.data;
        final errorText = isValid ? null : '1文字以上入力してください。';

        return TextField(
          minLines: 1,
          maxLines: 1,
          controller: this._controller,
          decoration: InputDecoration(hintText: '正規表現', errorText: errorText),
          onChanged: bloc.onRegexFilterPatternStringChanged,
        );
      });
}
