import 'package:flutter/material.dart';
import 'package:naples/src/navigation/will_pop_scope_navigation_widget.dart';
import 'package:naples/src/edit/dynamic_form.dart';
import 'package:naples/src/edit/get_loader.dart';
import 'package:naples/src/widgets/actions_widget.dart';
import 'package:naples/src/widgets/distribution_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:provider/provider.dart';

class SaveCancelWidget<T> extends StatefulWidget {
  final FunctionOf0<Future<T>> get;
  final FunctionOf1<T, Future<void>> set;
  final FunctionOf1<T, String> title;
  final FunctionOf1<T, Iterable<Widget>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  SaveCancelWidget({
    @required this.get,
    @required this.set,
    this.title,
    @required this.getLayoutMembers,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    Key key,
  }) : super(key: key);

  @override
  _SaveCancelWidgetState<T> createState() => _SaveCancelWidgetState<T>();
}

class _SaveCancelWidgetState<T> extends State<SaveCancelWidget<T>> {
  final _dynamicFormKey = GlobalKey<DynamicFormState>();
  bool _valid = false;

//TODO: Probablement el nom hauria de ser alguna cosa com edit_model enlloc de save_view
//TODO: Segurament el millor seria que aquest partís de item, i que
//en tot cas després hi hagués un altre widget que combinés el getloader + aquest

  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel>();
    return GetLoader<T>(
      get: widget.get,
      builder: (item, loading) {
        final properties = widget.getLayoutMembers(item);
        return WillPopScopeNavigationWidget(
          child: Scaffold(
            appBar: widget.title == null
                ? null
                : AppBar(
                    title: Text(widget.title(item)),
                  ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  DynamicForm(
                    key: _dynamicFormKey,
                    fixed: widget.fixed,
                    children: properties,
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
                                await widget.set(item); //Send the changes to the backend
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
            ),
          ),
        );
      },
    );
  }
}

//TODO: Localize
