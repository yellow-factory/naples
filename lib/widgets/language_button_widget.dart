import 'package:flutter/material.dart';
import 'package:yellow_naples/models.dart';
import 'package:provider/provider.dart';

class LanguageButtonWidget extends StatelessWidget {
  final String culture;

  LanguageButtonWidget(this.culture, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(culture.toUpperCase()),
      textColor: Colors.white,
      onPressed: () async {
        context.read<CurrentLanguageModel>().value = culture;
      },
    );
  }
}
