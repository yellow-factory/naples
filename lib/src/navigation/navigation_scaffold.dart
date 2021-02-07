import 'package:flutter/material.dart';
import 'package:naples/src/load/loading.dart';
import 'package:naples/src/navigation/will_pop_scope_navigation_widget.dart';

class NavigationScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget> actions;
  final FloatingActionButton floatingActionButton;

  NavigationScaffold({
    @required this.child,
    this.title,
    this.floatingActionButton,
    this.actions,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScopeNavigationWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title ?? ''),
          actions: actions == null || actions.length == 0 ? null : actions,
        ),
        body: Loading(
          child: child,
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
