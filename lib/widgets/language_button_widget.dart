import 'package:flutter/material.dart';
import 'package:naples/models.dart';
import 'package:provider/provider.dart';

class LanguageButtonWidget extends StatelessWidget {
  final String text;
  final String culture;

  LanguageButtonWidget(this.text, this.culture, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text.toUpperCase()),
      textColor: Colors.white,
      onPressed: () async {
        context.read<CurrentLanguageModel>().value = culture;
      },
    );
  }
}
