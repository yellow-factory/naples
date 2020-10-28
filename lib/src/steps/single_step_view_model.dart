import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:naples/src/view_models/edit/dynamic_form.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:navy/navy.dart';

class SingleStepViewModel<T> extends StatelessWidget {
  final NavigationModel navigationModel;
  final FunctionOf0<Future<T>> get;
  final FunctionOf0<Future<void>> set;
  final FunctionOf1<T, String> title;
  final FunctionOf1<T, Iterable<Expandable>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  SingleStepViewModel({
    @required this.navigationModel,
    @required this.get,
    this.set,
    this.title,
    @required this.getLayoutMembers,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    Key key,
  }) : super(key: key);

  // Iterable<VProperty> visibleProperties(T t) => getLayoutMembers(t)
  //     .whereType<ViewProperty>()
  //     .where((element) => element.isVisible == null || element.isVisible());

  bool valid(Iterable<ModelProperty> properties) {
    return true;
    //return properties.whereType<ModelProperty>().every((element) => element.validate() == null);
  }

  @override
  Widget build(BuildContext context) {
    return GetLoader<T>(
      get: get,
      builder: (item, loading) {
        final properties = getLayoutMembers(item);
        return BaseScaffoldWidget(
            title: title(item),
            child: Column(children: <Widget>[
              DynamicForm(
                fixed: fixed,
                children: properties,
                maxFlex: maxFlex,
                normalize: normalize,
                distribution: distribution,
              ),
              ActionsWidget(actions: <ActionWrap>[
                ActionWrap(
                  navigationModel.canGoForward ? "Continua" : "Finalitza",
                  action: () async {
                    // if (!valid) return;
                    // update(context); //Sends changes from widgets to the model
                    await set();
                    await navigationModel.forward();
                  },
                  primary: true,
                ),
                if (navigationModel.canGoBack)
                  ActionWrap(
                    "Torna",
                    action: () async {
                      await navigationModel.back();
                    },
                  ),
              ]),
            ]));
      },
    );
  }
}
