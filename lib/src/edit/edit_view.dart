import 'package:flutter/material.dart';
import 'package:naples/edit.dart';
import 'package:naples/navigation.dart';
import 'package:naples/widgets.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class EditView<T> extends StatefulWidget {
  final FunctionOf0<Future<void>> set;
  final Iterable<Widget> properties;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  EditView({
    @required this.set,
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
    var navigationModel = context.watch<NavigationModel>();
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
                title: "Save",
                action: !_valid
                    ? null
                    : () async {
                        await widget.set(); //Send the changes to the backend
                        await navigationModel.back(); //Returns to the previous view
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Saved!"),
                          ),
                        );
                      },
                primary: true,
              ),
              ActionWidget(
                title: "Cancel",
                action: () async {
                  await navigationModel.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//TODO: Localize