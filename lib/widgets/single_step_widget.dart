import 'package:flutter/material.dart';
import 'package:naples/view_models/common.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:naples/widgets/dynamic_form_widget.dart';
import 'package:provider/provider.dart';

class SingleStepWidget extends StatelessWidget {
  SingleStepWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StepViewModelController>();

    return BaseScaffoldWidget(
        child: Column(children: <Widget>[
      ChangeNotifierProvider<GetSetViewModel>.value(value: viewModel, child: DynamicFormWidget()),
      ActionsWidget(actions: <ActionWrap>[
        ActionWrap(
          viewModel.hasNextStep ? "Continua" : "Finalitza",
          action: () async => await viewModel.nextStep(),
          primary: true,
        ),
        if (viewModel.hasPreviousStep)
          ActionWrap(
            "Torna",
            action: () async => await viewModel.previousStep(),
          ),
      ]),
    ]));
  }
}
