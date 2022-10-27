import 'package:flutter/material.dart';

class ActionWidget extends StatelessWidget {
  final String title;
  final VoidCallback? action;
  final bool primary;
  const ActionWidget({super.key, required this.title, this.action, this.primary = false});

  @override
  Widget build(BuildContext context) {
    var txtTitle = Text(title.toUpperCase());
    if (primary) {
      return FocusTraversalOrder(
        order: const NumericFocusOrder(0),
        child: ElevatedButton(
          onPressed: action == null ? null : action!,
          child: txtTitle,
        ),
      );
    }
    return FocusTraversalOrder(
      order: const NumericFocusOrder(1),
      child: TextButton(
        onPressed: action,
        child: txtTitle,
      ),
    );
  }
}

class ActionsListWidget extends StatelessWidget {
  final List<ActionWidget> actions;

  const ActionsListWidget({Key? key, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ButtonBar(
          children: actions.reversed.toList(),
        ));
  }
}
