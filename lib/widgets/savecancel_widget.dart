import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'actions_widget.dart';
import 'base_scaffold_widget.dart';
import 'dynamic_form_widget.dart';
import 'package:provider/provider.dart';

class SaveCancelWidget extends StatelessWidget {
  SaveCancelWidget({Key key}) : super(key: key);

//TODO: Maybe "Save"/"Cancel" texts must be params of the widget...

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<SaveCancelViewModel>();

    return BaseScaffoldWidget(
        child: ActionsWidget(actions: <ActionWrap>[
      ActionWrap(
        title: "Save",
        action: () async => viewModel.update(),
      ),
      ActionWrap(
        title: "Cancel",
        action: () async => viewModel.cancel(),
      ),
    ], child: DynamicFormWidget()));
  }
}
