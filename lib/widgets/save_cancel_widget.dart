import 'package:flutter/material.dart';
import 'package:naples/view_models/common.dart';
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
      ChangeNotifierProvider<GetSetViewModel>.value(value: viewModel, child: DynamicFormWidget()),
      ActionsWidget(actions: <ActionWrap>[
        ActionWrap(
          "Save",
          action: () async => viewModel.save(),
          primary: true,
        ),
        ActionWrap(
          "Cancel",
          action: () async => viewModel.cancel(),
        ),
      ]),
    ]));
  }
}
