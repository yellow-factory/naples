import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class ValidForm extends StatefulWidget {
  //The form is not being validated until the user interacts with it
  //While the user does not interact with the form builder returns as valid the value of initialValid
  final Widget child;
  final FunctionOf1<ValidFormState, Widget>? builder;
  final bool initialValid;
  final ActionOf0? onChanged;
  final bool validateOnFormChanged;
  final bool saveOnFormChanged;

  const ValidForm({
    Key? key,
    required this.child,
    this.builder,
    this.initialValid = false,
    this.onChanged,
    this.validateOnFormChanged = false,
    this.saveOnFormChanged = true,
  }) : super(key: key);

  @override
  ValidFormState createState() => ValidFormState();

  static ValidFormState? of(BuildContext context) {
    final _ValidFormScope? scope = context.dependOnInheritedWidgetOfExactType<_ValidFormScope>();
    return scope?._formState;
  }
}

class _ValidFormScope extends InheritedWidget {
  const _ValidFormScope({
    Key? key,
    required Widget child,
    required ValidFormState formState,
  })  : _formState = formState,
        super(key: key, child: child);

  final ValidFormState _formState;

  ValidForm get form => _formState.widget;

  @override
  bool updateShouldNotify(_ValidFormScope old) => false;
}

class ValidFormState extends State<ValidForm> {
  final _formKey = GlobalKey<FormState>();
  late bool valid;
  late Form form;

  @override
  void initState() {
    super.initState();
    valid = widget.initialValid;
    _updateForm();
  }

  @override
  void didUpdateWidget(covariant ValidForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    refresh();
  }

  void _updateForm() {
    form = Form(
      key: _formKey,
      onChanged: _evaluateOnChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: _ValidFormScope(formState: this, child: widget.child),
    );
  }

  void _evaluateOnChanged() {
    if (widget.saveOnFormChanged) save();
    if (widget.validateOnFormChanged) validate();
    _fireOnChanged();
  }

  void _fireOnChanged() {
    if (widget.onChanged == null) return;
    scheduleMicrotask(widget.onChanged!);
  }

  void save() {
    var formState = _formKey.currentState;
    if (formState == null) return;
    formState.save();
  }

  void refresh() {
    _updateForm();
    _evaluateOnChanged();
  }

  bool validate() {
    return ifNotNullPredicateOf1<FormState>(
      _formKey.currentState,
      (currentState) {
        //It's necessary to call the form's save because the it's the way
        //to call the setProperty of the ModelProperty fields, and this is
        //is necessary because sometimes in the setProperty we change the
        //fields that are visible on the form.
        currentState.save();
        var isValid = currentState.validate();
        if (isValid != valid) {
          setState(() {
            valid = isValid;
          });
        }
        return valid;
      },
      valid,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder == null) return form;
    return widget.builder!(this);
  }
}
