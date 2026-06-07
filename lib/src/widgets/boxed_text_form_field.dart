import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:naples/src/widgets/field_scaffold.dart';

/// A boxed, labelled single- or multi-line text field whose validation error
/// renders BELOW the box — in the same slot as the inline help — instead of
/// inside it.
///
/// Material's [TextFormField] paints its validator error *inside* its
/// [InputDecorator], which (because the decorator lives inside our [FieldBox])
/// would grow the box and break the alignment of neighbouring fields in a row.
/// This widget sidesteps that by being a plain [FormField] over a borderless
/// [TextField]: the box height stays fixed and the error is drawn by
/// [FieldScaffold] under the box, exactly where the help line appears.
///
/// The value is always edited as text; numeric callers ([IntProperty],
/// [DoubleProperty]) parse it in their `validator`/`onSaved`.
class BoxedTextFormField extends FormField<String> {
  BoxedTextFormField({
    super.key,
    required String label,
    String? help,
    String? hintText,
    bool readOnlyLook = false,
    bool autofocus = false,
    bool obscureText = false,
    bool mono = false,
    String? unitSuffix,
    int minLines = 1,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
    List<Widget> actions = const [],
    super.initialValue,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
  }) : super(
          builder: (state) => _BoxedTextField(
            state: state,
            label: label,
            help: help,
            hintText: hintText,
            readOnlyLook: readOnlyLook,
            autofocus: autofocus,
            obscureText: obscureText,
            mono: mono,
            unitSuffix: unitSuffix,
            minLines: minLines,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            onChanged: onChanged,
            actions: actions,
          ),
        );
}

class _BoxedTextField extends StatefulWidget {
  final FormFieldState<String> state;
  final String label;
  final String? help;
  final String? hintText;
  final bool readOnlyLook;
  final bool autofocus;
  final bool obscureText;
  final bool mono;
  final String? unitSuffix;
  final int minLines;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final List<Widget> actions;

  const _BoxedTextField({
    required this.state,
    required this.label,
    required this.help,
    required this.hintText,
    required this.readOnlyLook,
    required this.autofocus,
    required this.obscureText,
    required this.mono,
    required this.unitSuffix,
    required this.minLines,
    required this.maxLines,
    required this.inputFormatters,
    required this.keyboardType,
    required this.onChanged,
    required this.actions,
  });

  @override
  State<_BoxedTextField> createState() => _BoxedTextFieldState();
}

class _BoxedTextFieldState extends State<_BoxedTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String? _lastValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.state.value ?? '');
    _focusNode = FocusNode();
    _lastValue = widget.state.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Re-seed the controller when the field value changes *externally* (e.g.
  /// Form.reset) — never while the user is typing (that would fight the
  /// cursor) and only when the text actually differs.
  void _syncFromState() {
    final v = widget.state.value;
    if (v == _lastValue) return;
    _lastValue = v;
    if (!_focusNode.hasFocus && (v ?? '') != _controller.text) {
      _controller.text = v ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _syncFromState();
    final t = NaplesFieldTokens.of(context);
    final roLook = widget.readOnlyLook;
    final multiline = widget.maxLines > 1;

    final field = TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: TextStyle(
        fontSize: widget.mono ? 13.5 : 15,
        color: roLook ? t.muted : t.text,
        fontFamilyFallback: widget.mono ? const ['JetBrains Mono', 'monospace'] : null,
        letterSpacing: widget.mono ? -0.1 : null,
      ),
      decoration: borderlessFieldDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: t.muted, fontSize: widget.mono ? 13.5 : 15),
      ),
      readOnly: roLook,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textAlignVertical: TextAlignVertical.top,
      onChanged: (v) {
        widget.state.didChange(v);
        widget.onChanged?.call(v);
      },
    );

    final boxChild = Row(
      crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Expanded(child: field),
        if (widget.unitSuffix != null && widget.unitSuffix!.isNotEmpty) ...[
          const SizedBox(width: 8),
          Text(
            widget.unitSuffix!,
            style: TextStyle(color: t.muted, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
        if (widget.actions.isNotEmpty) ...[
          const SizedBox(width: 4),
          ...widget.actions,
        ],
      ],
    );

    return FieldScaffold(
      label: widget.label,
      readOnly: roLook,
      help: widget.help,
      errorText: widget.state.errorText,
      child: FieldBox(
        readOnly: roLook,
        minHeight: multiline ? 78 : FieldBox.singleLineHeight,
        center: !multiline,
        padding: multiline
            ? const EdgeInsets.fromLTRB(12, 10, 12, 10)
            : const EdgeInsets.fromLTRB(12, 6, 6, 6),
        child: boxChild,
      ),
    );
  }
}
