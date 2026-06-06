import 'package:flutter/material.dart';
import 'package:naples/src/common/field_tokens.dart';

/// The boxed chrome shared by naples controls: token-driven fill + border,
/// an accent focus halo while a descendant holds focus, and a dashed border +
/// transparent fill in [readOnly] state so read-only reads differently at a
/// glance. Hosts a bare control (e.g. a borderless [TextField]) as [child].
class FieldBox extends StatefulWidget {
  /// Shared height for every single-line field control, so they all line up
  /// regardless of their inner content (text, numbers, tokens, pickers…).
  static const double singleLineHeight = 42;

  final Widget child;

  /// Read-only look: transparent fill, dashed border, no focus halo.
  final bool readOnly;

  final EdgeInsetsGeometry padding;
  final double? minHeight;

  /// When true, the child is vertically centred within [minHeight] (and the
  /// box still grows beyond it for taller content, e.g. a validation error).
  /// Use for single-line controls so they share one consistent height.
  final bool center;

  const FieldBox({
    super.key,
    required this.child,
    this.readOnly = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.minHeight,
    this.center = false,
  });

  @override
  State<FieldBox> createState() => _FieldBoxState();
}

class _FieldBoxState extends State<FieldBox> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final t = NaplesFieldTokens.of(context);
    final focused = _focused && !widget.readOnly;

    Widget content = Padding(padding: widget.padding, child: widget.child);
    if (widget.minHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.minHeight!),
        // Centre the content within minHeight (single-line), while still
        // allowing the box to grow taller for overflowing content.
        child: widget.center
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [content],
              )
            : content,
      );
    }

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (f) {
        if (f != _focused) setState(() => _focused = f);
      },
      child: CustomPaint(
        painter: _FieldBoxPainter(tokens: t, readOnly: widget.readOnly, focused: focused),
        child: content,
      ),
    );
  }
}

/// Strips Material's input chrome (borders, content padding) so a bare
/// `TextFormField` can sit cleanly inside a [FieldBox].
InputDecoration borderlessFieldDecoration({
  String? hintText,
  TextStyle? hintStyle,
  TextStyle? errorStyle,
}) {
  return InputDecoration(
    isDense: true,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: EdgeInsets.zero,
    hintText: hintText,
    hintStyle: hintStyle,
    errorStyle: errorStyle,
  );
}

/// A compact, muted 28×28 icon button for in-field actions (copy, edit, open,
/// clear, pick…), sized to fit a single-line [FieldBox] without inflating it.
class FieldActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const FieldActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 16),
      color: NaplesFieldTokens.of(context).muted,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
    );
  }
}

class _FieldBoxPainter extends CustomPainter {
  final NaplesFieldTokens tokens;
  final bool readOnly;
  final bool focused;

  _FieldBoxPainter({required this.tokens, required this.readOnly, required this.focused});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(tokens.radius);
    final rect = Offset.zero & size;
    // Inset by half the border width so the 1px stroke stays inside bounds.
    final rrect = RRect.fromRectAndRadius(rect.deflate(0.5), radius);

    // Focus halo (drawn first, sits behind the border).
    if (focused) {
      final halo = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = tokens.focusRing;
      canvas.drawRRect(rrect, halo);
    }

    // Fill (editable only).
    if (!readOnly) {
      canvas.drawRRect(rrect, Paint()..color = tokens.fieldBg);
    }

    // Border.
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = focused ? tokens.focus : tokens.fieldBorder;

    if (readOnly) {
      _drawDashedRRect(canvas, rrect, border);
    } else {
      canvas.drawRRect(rrect, border);
    }
  }

  void _drawDashedRRect(Canvas canvas, RRect rrect, Paint paint) {
    const dash = 4.0;
    const gap = 3.0;
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0.0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_FieldBoxPainter old) =>
      old.readOnly != readOnly || old.focused != focused || old.tokens != tokens;
}
