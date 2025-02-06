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
          onPressed: action,
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

  const ActionsListWidget({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: OverflowBar(
          children: actions.reversed.toList(),
        ));
  }
}
