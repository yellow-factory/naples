import 'package:flutter/material.dart';
import 'package:naples/src/common/field_help_scope.dart';
import 'package:naples/src/common/field_tokens.dart';

/// Shared layout for a labelled field: an external label (with a lock icon
/// when read-only) above the control, and an optional inline help line below
/// that appears only when an ancestor [FieldHelpScope] is visible.
class FieldScaffold extends StatelessWidget {
  final String label;
  final bool readOnly;
  final String? help;
  final Widget child;

  const FieldScaffold({
    super.key,
    required this.label,
    required this.child,
    this.readOnly = false,
    this.help,
  });

  @override
  Widget build(BuildContext context) {
    final t = NaplesFieldTokens.of(context);
    final showHelp = help != null && help!.trim().isNotEmpty && FieldHelpScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.12,
                  color: t.label,
                ),
              ),
            ),
            if (readOnly) ...[
              const SizedBox(width: 5),
              Icon(Icons.lock_outline, size: 12, color: t.muted),
            ],
          ],
        ),
        const SizedBox(height: 6),
        child,
        if (showHelp)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              help!,
              style: TextStyle(fontSize: 12, height: 1.35, color: t.help),
            ),
          ),
      ],
    );
  }
}
