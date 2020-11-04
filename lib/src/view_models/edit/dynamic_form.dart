import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:naples/edit.dart';
import 'package:navy/navy.dart';

class DynamicForm extends StatefulWidget {
  final Iterable<Expandable> children;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final EdgeInsetsGeometry childPadding;
  final ActionOf0 onChanged;
  final ActionOf1<bool> onValidChanged;

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
  }) : super(key: key);

  @override
  DynamicFormState createState() => DynamicFormState();
}

class DynamicFormState extends ValidableState<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  bool _valid = false;

  @override
  bool get valid => _valid;

  @override
  void initState() {
    super.initState();
    //TODO: maybe the widgets implementing ModelProperty can implement Validable?
    var isValid =
        widget.children.whereType<ModelProperty>().every((element) => element.initialValid);
    if (_valid != isValid) {
      _valid = isValid;
      if (widget.onValidChanged != null) {
        scheduleMicrotask(() => widget.onValidChanged(_valid));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
  }
}
