import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/widgets/distribution_widget.dart';

class DynamicForm extends StatefulWidget {
  final Iterable<ViewProperty> children;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final EdgeInsetsGeometry childPadding;

  DynamicForm(
      {Key key,
      this.children,
      this.fixed = 1,
      this.maxFlex = 1,
      this.normalize = true,
      this.distribution = DistributionType.LeftToRight,
      this.childPadding = const EdgeInsets.only(right: 10)})
      : super(key: key);

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: DistributionWidget(
        <Expandable>[
          for (var p in widget.children)
            Expandable(
                widget.childPadding == null
                    ? p.widget
                    : Container(
                        child: p.widget,
                        padding: widget.childPadding,
                      ),
                p.flex ?? 1)
        ],
        distribution: widget.distribution,
        fixed: widget.fixed,
        maxFlex: widget.maxFlex,
        normalize: widget.normalize,
      ),
    );
  }
}