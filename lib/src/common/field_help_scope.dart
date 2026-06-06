import 'package:flutter/widgets.dart';

/// Inherited flag that tells naples field widgets whether to reveal their
/// inline help/description text. A host app wraps a form subtree with
/// `FieldHelpScope(visible: ...)` and flips [visible] from a single global
/// "Help" toggle; every field below shows or hides its help line at once.
///
/// When absent, [FieldHelpScope.of] returns false (help hidden) so fields
/// degrade gracefully outside a scope.
class FieldHelpScope extends InheritedWidget {
  final bool visible;

  const FieldHelpScope({super.key, required this.visible, required super.child});

  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FieldHelpScope>();
    return scope?.visible ?? false;
  }

  @override
  bool updateShouldNotify(FieldHelpScope oldWidget) => visible != oldWidget.visible;
}
