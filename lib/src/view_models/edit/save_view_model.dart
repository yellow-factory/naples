import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/edit/edit_view_model.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/steps.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/navigation/navigation.dart';

class SaveCancelViewModel<T> extends StatefulWidget {
  final FunctionOf0<Future<T>> get;
  final FunctionOf1<T, Future<void>> set;
  final FunctionOf1<T, String> title;
  final FunctionOf1<T, Iterable<ViewProperty>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;
  final NavigationModel navigationModel;
  //SnackModel get snackModel => getProvided();

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
  Future<void> cancel() async {
    var back = await widget.navigationModel.back();
    print('Invoking back, result: $back');
  }

  Future<void> save(T item) async {
    // if (!valid) return;
    // update(); //Send the changes of the controls to the viewmodel
    await widget.set(item); //Send the changes to the backend
    await widget.navigationModel.back(); //Returns to the previous view
    //snackModel.message = "Saved!"; //Sends a snack message
  }

  Iterable<ViewProperty> visibleProperties(T t) => widget
      .getLayoutMembers(t)
      .whereType<ViewProperty>()
      .where((element) => element.isVisible == null || element.isVisible());

  @override
  Widget build(BuildContext context) {
    return GetLoader<T>(
      get: widget.get,
      builder: (item, loading) {
        return BaseScaffoldWidget(
          title: widget.title == null ? null : widget.title(item),
          child: Column(
            children: <Widget>[
              DynamicForm(
                fixed: widget.fixed,
                children: visibleProperties(item),
                maxFlex: widget.maxFlex,
                normalize: widget.normalize,
                distribution: widget.distribution,
              ),
              ActionsWidget(
                actions: <ActionWrap>[
                  ActionWrap(
                    "Save",
                    action: () async => save(item),
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
        );
      },
    );
  }
}
