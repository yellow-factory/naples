import 'package:flutter/material.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/widgets/field_box.dart';

class CheckboxFormField extends FormField<bool> {
  final bool showHintExplicitly;
  CheckboxFormField({
    super.key,
    required String label,
    String? hint,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    bool initialValue = false,
    bool autofocus = false,
    bool enabled = true,
    super.onSaved,
    super.validator,
    bool saveOnValueChanged = false,
    this.showHintExplicitly = false,
  }) : super(
         initialValue: initialValue,
         builder: (FormFieldState<bool> state) {
           return _CheckboxWidget(
             state: state,
             label: label,
             hint: hint,
             autofocus: autofocus,
             enabled: enabled,
             saveOnValueChanged: saveOnValueChanged,
             showHintExplicitly: showHintExplicitly,
           );
         },
       );
}

class _CheckboxWidget extends StatefulWidget {
  final FormFieldState<bool> state;
  final String label;
  final String? hint;
  final bool autofocus;
  final bool enabled;
  final bool saveOnValueChanged;
  final bool showHintExplicitly;

  const _CheckboxWidget({
    required this.state,
    required this.label,
    this.hint,
    required this.autofocus,
    required this.enabled,
    required this.saveOnValueChanged,
    required this.showHintExplicitly,
  });

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<_CheckboxWidget> {
  OverlayEntry? _overlayEntry;

  void _showTooltip() {
    if (_overlayEntry != null) return;
    if (widget.hint == null || widget.hint!.isEmpty) return;
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final theme = Theme.of(context);
    final tooltipTheme = theme.tooltipTheme;
    final Color bgColor = theme.colorScheme.inverseSurface;
    final Color textColor = theme.colorScheme.onInverseSurface;
    final textStyle = tooltipTheme.textStyle ?? TextStyle(fontSize: 12, color: textColor);
    final decoration = tooltipTheme.decoration ??
        BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4));

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: decoration,
            padding: tooltipTheme.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(widget.hint!, style: textStyle),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }

  static void _onChanged(
    bool enabled,
    bool? newValue,
    FormFieldState<bool> state,
    bool saveOnValueChanged,
  ) {
    if (!enabled) return;
    if (state.value == newValue) return;
    state.didChange(newValue);
    if (saveOnValueChanged) state.save();
  }

  @override
  Widget build(BuildContext context) {
    final t = NaplesFieldTokens.of(context);
    final showHint =
        widget.showHintExplicitly && widget.hint != null && widget.hint!.trim().isNotEmpty;

    return MouseRegion(
      onEnter: (_) => _showTooltip(),
      onExit: (_) => _hideTooltip(),
      // Boxed chrome with the shared single-line height so the checkbox lines
      // up with adjacent text fields (and the switch variant). See FieldBox.
      child: FieldBox(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minHeight: FieldBox.singleLineHeight,
        center: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Constrain to the same 24px footprint as the switch variant so the
            // FieldBox lands on the shared single-line height: a bare shrinkWrap +
            // compact checkbox is 32px and would push the box past 42.
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: widget.state.value,
                onChanged: widget.enabled
                    ? (bool? newValue) =>
                        _onChanged(widget.enabled, newValue, widget.state, widget.saveOnValueChanged)
                    : null,
                autofocus: widget.autofocus,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      widget.label,
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: t.text),
                    ),
                  ),
                  if (showHint)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        widget.hint!,
                        style: TextStyle(fontSize: 12.5, height: 1.35, color: t.help),
                      ),
                    ),
                  if (widget.state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        widget.state.errorText ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
