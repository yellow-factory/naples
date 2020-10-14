import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/view_models/edit/edit_view_model.dart';
import 'package:naples/src/view_models/edit/widgets/dynamic_form_widget.dart';
import 'package:naples/src/steps/widgets/single_step_widget.dart';
import 'package:provider/provider.dart';

mixin StepViewModelController<T> on EditViewModel<T> {
  NavigationModel get navigationModel => getProvided();

  bool get hasNextStep => navigationModel.canGoForward;

  Future<void> nextStep() async {
    if (!valid) return;
    update(); //Sends changes from widgets to the model
    await set(); //Sends changes from model to the backend
    await navigationModel.forward();
  }

  bool get hasPreviousStep => navigationModel.canGoBack;

  Future<void> previousStep() async {
    await navigationModel.back();
  }
}

abstract class RawStepViewModel<T> extends EditViewModel<T> with StepViewModelController<T> {
  RawStepViewModel(BuildContext context) : super(context);

  @override
  Widget get widget {
    return ChangeNotifierProvider<EditViewModel>.value(value: this, child: DynamicFormWidget());
  }
}

abstract class SingleStepViewModel<T> extends EditViewModel<T> with StepViewModelController<T> {
  SingleStepViewModel(BuildContext context) : super(context);

  @override
  Widget get widget {
    return ChangeNotifierProvider<StepViewModelController>.value(
        value: this, child: SingleStepWidget());
  }
}
