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
    // No Row wrapper here: the outer Flexible in _getActionsWithTitle imposes
    // a hard maxWidth, and we want that constraint to reach the Text directly
    // so its maxLines/ellipsis kick in. A wrapping Row(mainAxisSize.min) would
    // ask the child for its intrinsic width and bypass the ellipsis entirely.
    return badgeWidget ?? titleWidget!;
  }

  Widget? _getTitle(BuildContext context) {
    if (title == null) return null;
    return Tooltip(
      message: title!,
      child: Text(
        title!,
        // Long descriptions used as titles (model descriptions, instance
        // descriptions, etc.) shouldn't wrap or push the action buttons off
        // the right edge — clip with an ellipsis and rely on the tooltip for
        // the full text.
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
      ),
    );
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
        // Flexible (not Expanded) so a short title doesn't reserve more space
        // than it needs. Combined with the ellipsis in _getTitle this lets the
        // title shrink as the actions grow.
        if (titleBadgeWidget != null) Flexible(child: titleBadgeWidget),
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
