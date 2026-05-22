import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String? title;
  final String? chip;
  final List<Widget> actions;
  const TopBar({super.key, this.title, this.chip, this.actions = const []});

  Widget _getActions() {
    return OverflowBar(
      // When a title is present, this widget is placed as a non-flex Row child
      // on the right, so leaving alignment null lets it size to its intrinsic
      // width (children + spacing) instead of expanding via constraints.maxWidth.
      // Without a title, we fill the full width and use spaceBetween.
      alignment: title != null ? null : MainAxisAlignment.spaceBetween,
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
        // Expanded so the title fills all remaining width (its Text inside
        // is left-aligned with ellipsis, so short titles still appear at the
        // start). Actions sit at intrinsic width on the right — see
        // _getActions which returns an OverflowBar without an alignment when
        // a title is present.
        if (titleBadgeWidget != null) Expanded(child: titleBadgeWidget),
        _getActions(),
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
