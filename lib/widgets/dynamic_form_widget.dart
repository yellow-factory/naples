import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/widgets/distribution_widget.dart';
import 'package:provider/provider.dart';

class DynamicFormWidget extends StatefulWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final EdgeInsetsGeometry childPadding;

  DynamicFormWidget(
      {Key key,
      this.fixed = 1,
      this.maxFlex = 1,
      this.normalize = true,
      this.distribution = DistributionType.LeftToRight,
      this.childPadding = const EdgeInsets.only(right: 10)})
      : super(key: key);

  @override
  _DynamicFormWidgetState createState() => _DynamicFormWidgetState();
}

class _DynamicFormWidgetState extends State<DynamicFormWidget> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<GetSetViewModel>();
    return Form(
      key: _formKey,
      child: DistributionWidget(
        <Expandable>[
          for (var p in viewModel.visibleMembers)
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
