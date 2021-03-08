import 'package:flutter/material.dart';

class ActionWidget extends StatelessWidget {
  final String title;
  final VoidCallback? action;
  final bool primary;
  ActionWidget({required this.title, this.action, this.primary = false});

  @override
  Widget build(BuildContext context) {
    var txtTitle = Text(title.toUpperCase());
    if (primary)
      return ElevatedButton(
        child: txtTitle,
        onPressed: action == null ? null : action!,
      );
    return TextButton(
      child: txtTitle,
      onPressed: action,
    );
  }
}

class ActionsListWidget extends StatelessWidget {
  final List<ActionWidget> actions;

  ActionsListWidget({Key? key, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBar(children: actions.reversed.toList());
  }
}
