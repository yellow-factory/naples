import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'actions_widget.dart';
import 'base_scaffold_widget.dart';
import 'dynamic_form_widget.dart';
import 'package:provider/provider.dart';

class SaveCancelWidget extends StatelessWidget {
  SaveCancelWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SaveCancelViewModel>();

    return BaseScaffoldWidget(
        child: Column(children: <Widget>[
      DynamicFormWidget(<Expanded>[for (var p in viewModel.properties) p.widgetAsExpanded()]),
      ActionsWidget(actions: <ActionWrap>[
        ActionWrap(
          title: "Save",
          action: () async => viewModel.save(),
        ),
        ActionWrap(
          title: "Cancel",
          action: () async => viewModel.cancel(),
        ),
      ]),
    ]));
  }
}
