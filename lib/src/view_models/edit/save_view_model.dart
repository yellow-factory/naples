import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/edit/edit_view_model.dart';
import 'package:naples/src/view_models/edit/widgets/save_cancel_widget.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/models.dart';

abstract class SaveCancelViewModel<T> extends EditViewModel<T> {
  final NavigationModel navigationModel;
  SnackModel get snackModel => getProvided();

  SaveCancelViewModel(BuildContext context, this.navigationModel) : super(context);

  Future<void> cancel() async {
    var back = await navigationModel.back();
    print('Invoking back, result: $back');
  }

  Future<void> save() async {
    if (!valid) return;
    update(); //Send the changes of the controls to the viewmodel
    await set(); //Send the changes to the backend
    await navigationModel.back(); //Returns to the previous view
    snackModel.message = "Saved!"; //Sends a snack message
  }

//TODO: Igual que en el cas de SingleStepWidget, hauria de ser el SaveCancelWidget el que
//exposés GetSetViewModel, i no des d'aquí, que tingui només una responsabilitat

  @override
  Widget get widget {
    return MultiProvider(providers: [
      ChangeNotifierProvider<SaveCancelViewModel>.value(value: this), //used by SaveCancelWidget
      ChangeNotifierProvider<EditViewModel>.value(value: this) //used by DynamicFormWidget
    ], child: SaveCancelWidget());
  }
}
