import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String? title;
  final List<Widget> actions;
  const TopBar({
    Key? key,
    this.title,
    this.actions = const [],
  }) : super(key: key);

  Widget _getActions() {
    return OverflowBar(
      alignment: title != null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      spacing: 5,
      overflowSpacing: 5,
      overflowAlignment: OverflowBarAlignment.end,
      children: actions,
    );
  }

  Widget _getActionsWithTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        Expanded(
          child: _getActions(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 60),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: title != null ? _getActionsWithTitle() : _getActions(),
        ),
      ),
    );
  }
}
