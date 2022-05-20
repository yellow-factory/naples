import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class ValidForm extends StatefulWidget {
  final FunctionOf1<ValidFormState, Widget>? builder;
  final Widget child;
  final bool valid;
  const ValidForm({
    Key? key,
    required this.child,
    this.valid = false,
    this.builder,
  }) : super(key: key);

  @override
  State<ValidForm> createState() => ValidFormState();

  static ValidFormState? of(BuildContext context) {
    final _ValidFormScope? scope = context.dependOnInheritedWidgetOfExactType<_ValidFormScope>();
    return scope?._formState;
  }
}

class ValidFormState extends State<ValidForm> {
  final _formKey = GlobalKey<FormState>();
  late bool valid;
  late Form form;

  @override
  void initState() {
    super.initState();
    valid = widget.valid;
    form = Form(
        key: _formKey,
        onChanged: () => validate(),
        child: _ValidFormScope(
          formState: this,
          child: widget.child,
        ));
  }

  FormState? get formState => _formKey.currentState;

  bool validate() {
    var newValid = formState?.validate() ?? true;
    if (newValid == valid) return newValid;
    setState(() {
      valid = newValid;
    });
    return newValid;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder == null) return form;
    return widget.builder!(this);
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
