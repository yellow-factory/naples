import 'package:flutter/material.dart';

class ActionWidget extends StatelessWidget {
  final String title;
  final Function action;
  final bool primary;
  ActionWidget({@required this.title, this.action, this.primary = false});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(title.toUpperCase()),
      color: primary ? Theme.of(context).primaryColor : Theme.of(context).buttonColor,
      padding: EdgeInsets.all(15),
      onPressed: action == null
          ? null
          : () {
              action();
            },
    );
  }
}

class ActionsListWidget extends StatelessWidget {
  final List<ActionWidget> actions;

  ActionsListWidget({Key key, @required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBar(children: actions.reversed.toList());
  }
}
