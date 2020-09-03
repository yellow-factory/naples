import 'package:flutter/material.dart';
import 'package:yellow_naples/models.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/utils.dart';

class LanguageButtonWidget extends StatelessWidget {
  final String culture;
  final FunctionOf1<String, Future<bool>> initializeCulture;

  LanguageButtonWidget(this.culture, this.initializeCulture, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(culture.toUpperCase()),
      textColor: Colors.white,
      onPressed: () async {
        await initializeCulture(culture);
        context.read<CurrentLanguageModel>().value = culture;
      },
    );
  }
}
