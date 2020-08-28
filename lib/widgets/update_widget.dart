import 'package:flutter/material.dart';
import '../snack.dart';
import '../navigation.dart';
import 'actions_widget.dart';
import 'base_scaffold_widget.dart';
import 'dynamic_form_widget.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:provider/provider.dart';

class UpdateWidget extends StatelessWidget {
  UpdateWidget({Key key}) : super(key: key);

  Future<void> _update(BuildContext context) async {
    var viewModel = context.read<GetSetViewModel>();
    if (!viewModel.valid) return;
    viewModel.update(); //Envia els canvis dels controls al viewmodel
    await viewModel.set(); //Envia els canvis al backend
    await Provider.of<NavigationModel>(context, listen: false)
        .back(); //Torna a la pantalla anterior
    Provider.of<SnackModel>(context, listen: false).message =
        "Updated!"; //Envia un missatge a la pantalla
  }

  Future<void> _cancel(BuildContext context) async {
    var back = await Provider.of<NavigationModel>(context, listen: false).back();
    print('Cancelling: $back');
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
        child: ActionsWidget(actions: <ActionWrap>[
      ActionWrap(
        title: "Update",
        action: () async => _update(context),
      ),
      ActionWrap(
        title: "Cancel",
        action: () async => _cancel(context),
      ),
    ], child: DynamicFormWidget()));
  }
}
