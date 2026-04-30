import 'package:flutter/material.dart';

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

  static Widget _getSubtitle(String? hint, FormFieldState<bool> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [if (hint != null) Text(hint), if (state.hasError) _getErrorText(state)],
    );
  }

  static Widget _getErrorText(FormFieldState<bool> state) {
    final errorColor = Theme.of(state.context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(state.errorText ?? '', style: TextStyle(color: errorColor, fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showTooltip(),
      onExit: (_) => _hideTooltip(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Transform.translate(
                offset: const Offset(-11, 0),
                child: Checkbox(
                  value: widget.state.value,
                  onChanged: widget.enabled
                      ? (bool? newValue) =>
                          _onChanged(widget.enabled, newValue, widget.state, widget.saveOnValueChanged)
                      : null,
                  autofocus: widget.autofocus,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              Flexible(child: Text(widget.label)),
            ],
          ),
          if (widget.showHintExplicitly) _getSubtitle(widget.hint, widget.state),
          if (!widget.showHintExplicitly && widget.state.hasError) _getErrorText(widget.state),
        ],
      ),
    );
  }
}
