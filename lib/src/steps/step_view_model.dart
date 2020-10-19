import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/view_models/edit/edit_view_model.dart';
import 'package:naples/src/view_models/edit/dynamic_form.dart';
import 'package:provider/provider.dart';

//Tot això ja no té sentit

// mixin StepViewModelController<T> on EditViewModel<T> {
//   NavigationModel get navigationModel => getProvided();

//   bool get hasNextStep => navigationModel.canGoForward;

//   Future<void> nextStep() async {
//     // if (!valid) return;
//     // update(context); //Sends changes from widgets to the model
//     await set(); //Sends changes from model to the backend
//     await navigationModel.forward();
//   }

//   bool get hasPreviousStep => navigationModel.canGoBack;

//   Future<void> previousStep() async {
//     await navigationModel.back();
//   }
// }

// class RawStepViewModel<T> extends StatelessWidget {
//   NavigationModel get navigationModel => getProvided();

//   RawStepViewModel() : super();

//   @override
//   Widget build(BuildContext context) {
    

//   }
// }


