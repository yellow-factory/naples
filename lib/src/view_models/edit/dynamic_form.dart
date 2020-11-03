import 'package:flutter/material.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:naples/edit.dart';

class DynamicForm extends StatefulWidget {
  final Iterable<Expandable> children;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final EdgeInsetsGeometry childPadding;
  final VoidCallback onChanged;

  DynamicForm(
      {Key key,
      this.children,
      this.fixed = 1,
      this.maxFlex = 1,
      this.normalize = true,
      this.distribution = DistributionType.LeftToRight,
      this.childPadding = const EdgeInsets.only(right: 10),
      this.onChanged})
      : super(key: key);

  @override
  DynamicFormState createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  bool _valid = false;

  bool get valid => _valid;

  @override
  void initState() {
    _valid = !widget.children.whereType<ModelProperty>().any((element) => !element.initialValid);
    super.initState();
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
        setState(() {
          _valid = isValid;
        });
        if (widget.onChanged != null) widget.onChanged();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
