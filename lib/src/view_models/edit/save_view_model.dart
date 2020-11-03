import 'package:flutter/widgets.dart';
import 'package:naples/models.dart';
import 'package:naples/src/navigation/will_pop_scope_navigation_widget.dart';
import 'package:naples/src/view_models/edit/dynamic_form.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/back_forward_animation_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:provider/provider.dart';

class SaveCancelViewModel<T> extends StatelessWidget {
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

  Future<void> cancel() async {
    var back = await navigationModel.back();
    print('Invoking back, result: $back');
  }

  Future<void> save(BuildContext context, T item) async {
    await set(item); //Send the changes to the backend
    await navigationModel.back(); //Returns to the previous view
    var snackModel = context.read<SnackModel>();
    snackModel.message = "Saved!"; //Sends a snack message
  }

  bool valid(Iterable<Expandable> properties) {
    return true;
    //return properties.every((element) => element.isValid(element) == null);
  }

  @override
  Widget build(BuildContext context) {
    return GetLoader<T>(
      get: get,
      builder: (item, loading) {
        final properties = getLayoutMembers(item);
        return WillPopScopeNavigationWidget(
          child: BaseScaffoldWidget(
            title: title == null ? null : title(item),
            child: Column(
              children: <Widget>[
                DynamicForm(
                  fixed: fixed,
                  children: properties,
                  maxFlex: maxFlex,
                  normalize: normalize,
                  distribution: distribution,
                ),
                ActionsWidget(
                  actions: <ActionWrap>[
                    ActionWrap(
                      "Save",
                      action: !valid(properties)
                          ? null
                          : () async {
                              if (!valid(properties)) {
                                print("Invalid properties");
                                return;
                              }
                              save(context, item);
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
