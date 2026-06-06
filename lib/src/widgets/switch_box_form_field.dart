import 'package:flutter/material.dart';
import 'package:naples/src/common/field_help_scope.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/widgets/field_box.dart';

/// A boolean control rendered as a bordered box containing a switch and the
/// label to its right (handoff §6 "bool"). The label lives inside the box (no
/// external label), and the help line appears under the label when an ancestor
/// [FieldHelpScope] is visible.
class SwitchBoxFormField extends FormField<bool> {
  SwitchBoxFormField({
    super.key,
    required String label,
    String? help,
    bool initialValue = false,
    bool enabled = true,
    super.onSaved,
    super.validator,
    bool saveOnValueChanged = false,
    ValueChanged<bool>? onImmediateChange,
  }) : super(
          initialValue: initialValue,
          builder: (state) => _SwitchBox(
            state: state,
            label: label,
            help: help,
            enabled: enabled,
            onToggle: (v) {
              state.didChange(v);
              if (saveOnValueChanged) onImmediateChange?.call(v);
            },
          ),
        );
}

class _SwitchBox extends StatelessWidget {
  final FormFieldState<bool> state;
  final String label;
  final String? help;
  final bool enabled;
  final ValueChanged<bool> onToggle;

  const _SwitchBox({
    required this.state,
    required this.label,
    required this.help,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = NaplesFieldTokens.of(context);
    final value = state.value ?? false;
    final showHelp = help != null && help!.trim().isNotEmpty && FieldHelpScope.of(context);

    return FieldBox(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      minHeight: FieldBox.singleLineHeight,
      center: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MiniSwitch(
            value: value,
            onChanged: enabled ? onToggle : null,
            tokens: t,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: t.text,
                    ),
                  ),
                ),
                if (showHelp)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      help!,
                      style: TextStyle(fontSize: 12.5, height: 1.35, color: t.help),
                    ),
                  ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      state.errorText ?? '',
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
    );
  }
}

/// A compact 42×24 track switch with a white knob, matching the handoff.
class _MiniSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final NaplesFieldTokens tokens;

  const _MiniSwitch({required this.value, required this.onChanged, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return Opacity(
      opacity: enabled ? 1 : 0.6,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 42,
          height: 24,
          decoration: BoxDecoration(
            color: value ? tokens.accent : tokens.switchTrackOff,
            borderRadius: BorderRadius.circular(999),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 160),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
