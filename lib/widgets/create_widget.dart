import 'package:flutter/material.dart';
import '../snack.dart';
import 'actions_widget.dart';
import 'base_scaffold_widget.dart';
import 'dynamic_form_widget.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';

class CreateWidget extends StatelessWidget {
  CreateWidget({Key key}) : super(key: key);

  void _action(BuildContext context) async {
    var viewModel = context.read<GetSetViewModel>();
    if (!viewModel.valid) return;
    viewModel.update(); //Envia els canvis al viewModel
    await viewModel.set(); //Envia els canvis al backend
    await Provider.of<NavigationModel>(context, listen: false)
        .back(); //Torna a la pantalla anterior
    Provider.of<SnackModel>(context, listen: false).message =
        "Created!"; //Envia un missatge a la pantalla
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
        child: ActionsWidget(actions: <ActionWrap>[
      ActionWrap(
        title: "Create",
        action: () => _action(context),
      ),
    ], child: DynamicFormWidget()));
  }
}
