import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/src/dialogs/accept_cancel_delete_dialog.dart';
import 'package:navy/navy.dart';

class CustomProperty<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final FunctionOf0<FutureOr<String>> description;
  final FunctionOf1<T?, Widget> editContent;
  final FunctionOf0<bool>? onContentValidated;
  //The content notifies the CustomProperty that the content has changed and establish the new value
  final FunctionOf0<T?>? onContentChanged;
  final double editContentWidth;
  final Function? delete;
  final PredicateOf0? editable;
  final FunctionOf1<T?, String?>? validator;
  final FunctionOf0<T?> getProperty;
  final ActionOf1<T?>? setProperty;
  //The control notifies the CustomProperty that the value has changed
  final ActionOf1<T?>? onChanged;

  const CustomProperty({
    super.key,
    required this.label,
    this.hint,
    required this.description,
    required this.editContent,
    this.onContentValidated,
    this.onContentChanged,
    this.editContentWidth = 300,
    this.delete,
    this.editable,
    this.validator,
    required this.getProperty,
    this.setProperty,
    this.onChanged,
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
    _descriptionController.text = await widget.description();
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
    var dialogResult = await showDialog<AcceptCancelDeleteDialogOptions>(
      context: context,
      builder: (context) {
        return AcceptCancelDeleteDialog(
          title: widget.label,
          subtitle: widget.hint,
          showDelete: widget.delete != null,
          validate: widget.onContentValidated,
          child: SingleChildScrollView(
            child: SizedBox(
              width: widget.editContentWidth,
              child: widget.editContent(currentValue),
            ),
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
        return TextField(
          controller: _descriptionController,
          readOnly: true,
          enabled: widget.editable?.call() ?? true,
          autofocus: false,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: formFieldState.errorText,
            suffixIcon:
                widget.editable?.call() ?? true
                    ? IconButton(
                      onPressed: () => _showSelectDialog(formFieldState.value),
                      icon: const Icon(Icons.edit_outlined),
                    )
                    : null,
          ),
        );
      },
    );
  }
}
