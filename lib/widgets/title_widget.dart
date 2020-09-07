import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/models.dart';

class TitleWidget extends StatelessWidget {
  TitleWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = context.watch<TitleModel>();
    return Text(title.value());
  }
}
