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
  final ActionOf0 onChanged;
  final ActionOf1<bool> onValidChanged;
  final FunctionOf2<Widget, bool, Widget> builder;

  DynamicForm({
    Key key,
    this.children,
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
      if (widget.onValidChanged != null) {
        scheduleMicrotask(() => widget.onValidChanged(_valid));
      }
    }
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
        if (_formKey.currentState == null) return;
        _formKey.currentState.save();
        var isValid = _formKey.currentState.validate();
        if (_valid != isValid) {
          setState(() {
            _valid = isValid;
          });
          if (widget.onValidChanged != null) {
            scheduleMicrotask(() => widget.onValidChanged(_valid));
          }
        }
        if (widget.onChanged != null) {
          scheduleMicrotask(widget.onChanged);
        }
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
    if (widget.builder == null) return form;
    return widget.builder(form, _valid);
  }
}
