import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/widgets/actions_widget.dart';
import 'package:yellow_naples/widgets/base_scaffold_widget.dart';
import 'package:yellow_naples/widgets/dynamic_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/view_models/view_model.dart';

class StepWidget extends StatelessWidget {
  StepWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<StepViewModel>();
    //DynamicFormWidget depends on GetSetViewModel, this is the reason
    //why we register a notifier for GetSetViewModel with the same view
    return ChangeNotifierProvider<GetSetViewModel>.value(
        value: viewModel,
        child: BaseScaffoldWidget(
            child: ActionsWidget(actions: <ActionWrap>[
          ActionWrap(
            title: "Continua",
            action: () async => await viewModel.next(),
          ),
          ActionWrap(
            title: "Torna",
            action: () async => await viewModel.previous(),
          ),
        ], child: DynamicFormWidget())));
  }
}
