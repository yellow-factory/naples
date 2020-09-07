import 'package:flutter/material.dart';
import './snack_widget.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/view_models/view_model.dart';

class BaseScaffoldWidget extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;
  final FloatingActionButton floatingAction;
  final double padding;

  BaseScaffoldWidget(
      {@required this.child, this.actions, this.floatingAction, this.padding = 16, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = context.watch<TitleModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title.value()),
        actions: actions,
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SnackModelWidget(child: child),
      ),
      floatingActionButton: floatingAction,
    );
  }
}
