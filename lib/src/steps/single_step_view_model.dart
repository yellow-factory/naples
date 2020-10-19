import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:naples/src/view_models/edit/dynamic_form.dart';
import 'package:naples/src/view_models/edit/get_loader.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:navy/navy.dart';

class SingleStepViewModel<T> extends StatelessWidget {
  final NavigationModel navigationModel;
  final FunctionOf0<Future<T>> get;
  final FunctionOf0<Future<void>> set;
  final FunctionOf1<T, String> title;

  SingleStepViewModel({
    @required this.navigationModel,
    @required this.get,
    this.set,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetLoader<T>(
      get: get,
      builder: (item, loading) {
        return BaseScaffoldWidget(
            title: title(item),
            child: Column(children: <Widget>[
              DynamicForm(),
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
