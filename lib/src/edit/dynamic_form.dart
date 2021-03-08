import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/src/widgets/distribution_widget.dart';
import 'package:naples/edit.dart';
import 'package:navy/navy.dart';

class DynamicForm extends StatefulWidget implements Validable {
  final Iterable<Widget> children;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final EdgeInsetsGeometry childPadding;
  final ActionOf0? onChanged;
  final ActionOf1<bool>? onValidChanged;
  final FunctionOf2<Widget, bool, Widget>? builder;

  DynamicForm({
    Key? key,
    required this.children,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    this.childPadding = const EdgeInsets.only(right: 10),
    this.onChanged,
    this.onValidChanged,
    this.builder,
  }) : super(key: key);

  @override
  DynamicFormState createState() => DynamicFormState();

  @override
  bool get initialValid =>
      children.whereType<ModelProperty>().every((element) => element.initialValid);
}

class DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  bool _valid = false;

  @override
  void initState() {
    super.initState();
    //TODO: maybe the widgets implementing ModelProperty can implement Validable?
    var isValid = widget.initialValid;
    if (_valid != isValid) {
      _valid = isValid;
      _fireOnValidChanged();
    }
  }

  void _fireOnValidChanged() {
    ifNotNullActionOf1(
      widget.onValidChanged,
      (ActionOf1<bool> onValidChanged) => scheduleMicrotask(() => onValidChanged(_valid)),
    );
  }

  void _fireOnChanged() {
    ifNotNullActionOf1(
      widget.onChanged,
      (ActionOf0 onChanged) => scheduleMicrotask(onChanged),
    );
  }

  @override
  Widget build(BuildContext context) {
    var form = Form(
      key: _formKey,
      child: DistributionWidget(
        children: widget.children,
        distribution: widget.distribution,
        fixed: widget.fixed,
        maxFlex: widget.maxFlex,
        normalize: widget.normalize,
        childPadding: widget.childPadding,
      ),
      onChanged: () {
        ifNotNullActionOf1<FormState>(_formKey.currentState, (currentState) {
          currentState.save();
          var isValid = currentState.validate();
          if (_valid != isValid) {
            setState(() {
              _valid = isValid;
            });
            _fireOnValidChanged();
          }
          _fireOnChanged();
        });
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );

    return ifNotNullFunctionOf1<FunctionOf2<Widget, bool, Widget>, Widget>(
      widget.builder,
      (builder) => builder(form, _valid),
      form,
    );
  }
}
