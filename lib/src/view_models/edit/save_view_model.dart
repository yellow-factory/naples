import 'package:flutter/widgets.dart';
import 'package:naples/models.dart';
import 'package:naples/src/navigation/will_pop_scope_navigation_widget.dart';
import 'package:naples/src/view_models/edit/dynamic_form.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:provider/provider.dart';

class SaveCancelViewModel<T> extends StatefulWidget {
  final FunctionOf0<Future<T>> get;
  final FunctionOf1<T, Future<void>> set;
  final FunctionOf1<T, String> title;
  final FunctionOf1<T, Iterable<Expandable>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final NavigationModel navigationModel;

  SaveCancelViewModel({
    @required this.get,
    @required this.set,
    this.title,
    @required this.getLayoutMembers,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    this.navigationModel,
    Key key,
  }) : super(key: key);

  @override
  _SaveCancelViewModelState<T> createState() => _SaveCancelViewModelState<T>();
}

class _SaveCancelViewModelState<T> extends State<SaveCancelViewModel<T>> {
  final _dynamicFormKey = GlobalKey<DynamicFormState>();
  bool _valid = false;

  Future<void> cancel() async {
    var back = await widget.navigationModel.back();
    print('Invoking back, result: $back');
  }

  Future<void> save(BuildContext context, T item) async {
    await widget.set(item); //Send the changes to the backend
    await widget.navigationModel.back(); //Returns to the previous view
    var snackModel = context.read<SnackModel>();
    snackModel.message = "Saved!"; //Sends a snack message
  }

  @override
  Widget build(BuildContext context) {
    return GetLoader<T>(
      get: widget.get,
      builder: (item, loading) {
        final properties = widget.getLayoutMembers(item);
        return WillPopScopeNavigationWidget(
          child: BaseScaffoldWidget(
            title: widget.title == null ? null : widget.title(item),
            child: Column(
              children: <Widget>[
                DynamicForm(
                  key: _dynamicFormKey,
                  fixed: widget.fixed,
                  children: properties,
                  maxFlex: widget.maxFlex,
                  normalize: widget.normalize,
                  distribution: widget.distribution,
                  onChanged: () {
                    setState(() {
                      _valid = _dynamicFormKey.currentState.valid;
                    });
                  },
                ),
                ActionsWidget(
                  actions: <ActionWrap>[
                    ActionWrap(
                      "Save",
                      action: !_valid
                          ? null
                          : () async {
                              await save(context, item);
                            },
                      primary: true,
                    ),
                    ActionWrap(
                      "Cancel",
                      action: () async => cancel(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
