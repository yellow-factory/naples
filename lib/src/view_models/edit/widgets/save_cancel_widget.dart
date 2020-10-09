import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/edit_view_model.dart';
import 'package:naples/src/view_models/edit/save_view_model.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'dynamic_form_widget.dart';
import 'package:provider/provider.dart';

class SaveCancelWidget extends StatelessWidget {
  SaveCancelWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SaveCancelViewModel>();
    return BaseScaffoldWidget(
        child: Column(children: <Widget>[
      ChangeNotifierProvider<EditViewModel>.value(value: viewModel, child: DynamicFormWidget()),
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
