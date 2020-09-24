import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/widgets/actions_widget.dart';
import 'package:yellow_naples/widgets/base_scaffold_widget.dart';
import 'package:yellow_naples/widgets/dynamic_form_widget.dart';
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
          title: viewModel.hasNextStep ? "Continua" : "Finalitza",
          action: () async => await viewModel.nextStep(),
        ),
        if (viewModel.hasPreviousStep)
          ActionWrap(
            title: "Torna",
            action: () async => await viewModel.previousStep(),
          ),
      ]),
    ]));
  }
}
