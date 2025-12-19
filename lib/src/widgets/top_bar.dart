import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String? title;
  final String? chip;
  final List<Widget> actions;
  const TopBar({super.key, this.title, this.chip, this.actions = const []});

  Widget _getActions() {
    return OverflowBar(
      alignment: title != null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
      spacing: 5,
      overflowSpacing: 5,
      overflowAlignment: OverflowBarAlignment.end,
      children: actions,
    );
  }

  Widget? _getTitleChip(BuildContext context) {
    var titleWidget = _getTitle(context);
    var badgeWidget = _getChip(context);
    if (titleWidget == null && badgeWidget == null) return null;
    return Row(children: [badgeWidget ?? titleWidget!]);
  }

  Widget? _getTitle(BuildContext context) {
    return title != null
        ? Text(title!, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary))
        : null;
  }

  //TOREMOVE
  Widget? _getChip(BuildContext context) {
    return chip != null
        ? Badge(
            offset: const Offset(20, -4),
            backgroundColor: Theme.of(context).colorScheme.primary,
            label: Text(chip!),
            child: _getTitle(context),
          )
        : null;
  }

  Widget _getActionsWithTitle(BuildContext context) {
    var titleBadgeWidget = _getTitleChip(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      spacing: titleBadgeWidget != null ? 5 : 0,
      children: [
        if (titleBadgeWidget != null) titleBadgeWidget,
        Expanded(child: _getActions()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60, maxHeight: 60),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: title != null ? _getActionsWithTitle(context) : _getActions(),
        ),
      ),
    );
  }
}
