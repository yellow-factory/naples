import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/dialogs/accept_cancel_delete_dialog.dart';
import 'package:naples/src/dialogs/close_dialog.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:naples/src/widgets/field_scaffold.dart';
import 'package:navy/navy.dart';

/// Replacement for [CustomProperty]'s built-in edit dialog. Receives the
/// current value and returns the outcome: `null` when the user cancelled,
/// `(cleared: true, value: null)` when they removed the value (routed to
/// [CustomProperty.delete]) and `(cleared: false, value: v)` on a new choice.
typedef CustomPropertyDialogOpener<T> = Future<({bool cleared, T? value})?> Function(
  BuildContext context,
  T? currentValue,
);

class CustomProperty<T> extends StatefulWidget implements Expandable {
  final String label;
  final String? hint;

  /// Inline help shown below the control when the global help toggle is on.
  final String? help;
  final FunctionOf0<FutureOr<String>> description;
  final FunctionOf1<T?, Widget> content;

  /// When set, tapping edit calls this instead of opening the built-in
  /// accept/cancel/delete dialog around [content]. The read-only (eye) dialog
  /// still uses [content].
  final CustomPropertyDialogOpener<T>? dialogOpener;
  final FunctionOf0<bool>? onContentValidated;
  //The content notifies the CustomProperty that the content has changed and establish the new value
  final FunctionOf0<T?>? onContentChanged;
  final double contentWidth;
  final Function? delete;
  final PredicateOf0? editable;
  final FunctionOf1<T?, String?>? validator;
  final FunctionOf0<T?> getProperty;
  final ActionOf1<T?>? setProperty;
  //The control notifies the CustomProperty that the value has changed
  final ActionOf1<T?>? onChanged;
  @override
  final int flex;

  const CustomProperty({
    super.key,
    required this.label,
    this.hint,
    this.help,
    required this.description,
    required this.content,
    this.dialogOpener,
    this.onContentValidated,
    this.onContentChanged,
    this.contentWidth = 300,
    this.delete,
    this.editable,
    this.validator,
    required this.getProperty,
    this.setProperty,
    this.onChanged,
    this.flex = 1,
  });

  @override
  State<CustomProperty> createState() => _CustomPropertyState<T>();
}

class _CustomPropertyState<T> extends State<CustomProperty<T>> {
  final _formFieldKey = GlobalKey<FormFieldState<T>>();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initDescription();
  }

  Future<void> initDescription() async {
    if (!mounted) return;
    final description = await widget.description();
    if (!mounted) return;
    _descriptionController.text = description;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    await widget.delete!();
    if (mounted) _descriptionController.text = '';
  }

  Future<void> _set(T? newValue) async {
    widget.setProperty?.call(newValue);
    if (mounted) _descriptionController.text = await widget.description();
  }

  Future<void> _showSelectDialog(T? currentValue) async {
    if ((widget.editable?.call() ?? true) == false) {
      await showDialog(
        context: context,
        builder: (context) {
          return CloseDialog(
            title: widget.label,
            subtitle: widget.hint,
            child: SingleChildScrollView(
              child: SizedBox(width: widget.contentWidth, child: widget.content(currentValue)),
            ),
          );
        },
      );
      return;
    }

    final opener = widget.dialogOpener;
    if (opener != null) {
      final result = await opener(context, currentValue);
      if (result == null) {
        // Cancelled — restore whatever the form field last held.
        _formFieldKey.currentState?.reset();
        return;
      }
      if (result.cleared) {
        if (widget.delete != null) await _delete();
        return;
      }
      _formFieldKey.currentState?.didChange(result.value);
      widget.onChanged?.call(result.value);
      if (mounted) _descriptionController.text = await widget.description();
      return;
    }

    var dialogResult = await showDialog<AcceptCancelDeleteDialogOptions>(
      context: context,
      builder: (context) {
        return AcceptCancelDeleteDialog(
          title: widget.label,
          subtitle: widget.hint,
          showDelete: widget.delete != null,
          validate: widget.onContentValidated,
          child: SingleChildScrollView(
            child: SizedBox(width: widget.contentWidth, child: widget.content(currentValue)),
          ),
        );
      },
    );
    _executeDialogResult(dialogResult ?? AcceptCancelDeleteDialogOptions.cancel);
  }

  Future<void> _executeDialogResult(AcceptCancelDeleteDialogOptions result) async {
    switch (result) {
      case AcceptCancelDeleteDialogOptions.delete:
        await _delete();
        break;
      case AcceptCancelDeleteDialogOptions.accept:
        //If the value is valid and accepted, the value continues it's flowing state
        if (widget.onContentChanged != null) {
          var newValue = widget.onContentChanged!();
          _formFieldKey.currentState?.didChange(newValue);
        }
        widget.onChanged?.call(_formFieldKey.currentState?.value);
        if (mounted) _descriptionController.text = await widget.description();
        break;
      case AcceptCancelDeleteDialogOptions.cancel:
        // If the editing is cancelled, reset the form field to its initial state
        _formFieldKey.currentState?.reset();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: _formFieldKey,
      validator: widget.validator,
      initialValue: widget.getProperty(),
      onSaved: (t) => _set(t),
      builder: (FormFieldState<T> formFieldState) {
        final t = NaplesFieldTokens.of(context);
        final isEditable = widget.editable?.call() ?? true;
        final roLook = !isEditable;

        return FieldScaffold(
          label: widget.label,
          readOnly: roLook,
          help: widget.help,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldBox(
                readOnly: roLook,
                padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                minHeight: FieldBox.singleLineHeight,
                center: true,
                child: Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _descriptionController,
                        builder: (context, value, _) {
                          final empty = value.text.isEmpty;
                          return Text(
                            empty ? (widget.hint ?? '—') : value.text,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: empty ? FontWeight.w400 : FontWeight.w600,
                              color: empty ? t.muted : t.text,
                            ),
                          );
                        },
                      ),
                    ),
                    FieldActionButton(
                      icon: isEditable ? Icons.edit_outlined : Icons.remove_red_eye_outlined,
                      onPressed: () => _showSelectDialog(formFieldState.value),
                    ),
                  ],
                ),
              ),
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    formFieldState.errorText ?? '',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
