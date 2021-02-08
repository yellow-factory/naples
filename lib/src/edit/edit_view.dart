import 'package:flutter/material.dart';
import 'package:naples/edit.dart';
import 'package:naples/widgets.dart';

class EditView<T> extends StatefulWidget {
  final Function save;
  final Function cancel;
  final String saveText;
  final String cancelText;
  final Iterable<Widget> properties;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  EditView({
    @required this.save,
    @required this.cancel,
    @required this.saveText,
    @required this.cancelText,
    @required this.properties,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    Key key,
  }) : super(key: key);

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final _dynamicFormKey = GlobalKey<DynamicFormState>();
  bool _valid = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          DynamicForm(
            key: _dynamicFormKey,
            fixed: widget.fixed,
            children: widget.properties,
            maxFlex: widget.maxFlex,
            normalize: widget.normalize,
            distribution: widget.distribution,
            onValidChanged: (valid) {
              setState(() {
                _valid = valid;
              });
            },
          ),
          ActionsListWidget(
            actions: <ActionWidget>[
              ActionWidget(
                title: widget.saveText,
                action: !_valid ? null : widget.save,
                primary: true,
              ),
              ActionWidget(
                title: widget.cancelText,
                action: widget.cancel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
