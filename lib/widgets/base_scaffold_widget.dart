import 'package:flutter/material.dart';
import 'package:naples/widgets/title_widget.dart';
import './snack_widget.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: TitleWidget(),
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
