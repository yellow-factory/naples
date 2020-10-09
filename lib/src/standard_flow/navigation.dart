import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/view_model.dart';

//Possible transition states
enum StandardFlow { List, Create, Update }

// T is the type of the param used to navigate from list to update
class ListCreateUpdateStandardNavigationModel<T> extends NavigationModel<StandardFlow> {
  final FunctionOf0<ViewModel> _createCreateViewModel;
  final FunctionOf0<ViewModel> _createUpdateViewModel;

  ListCreateUpdateStandardNavigationModel(FunctionOf0<ViewModel> createListViewModel,
      this._createCreateViewModel, this._createUpdateViewModel)
      : super(StandardFlow.List, createListViewModel) {
    addTransition(StandardFlow.List, StandardFlow.Create, _createCreateViewModel);
    addTransition(StandardFlow.List, StandardFlow.Update, _createUpdateViewModel);
  }

  @override
  Widget get widget {
    return
        //The Navigation flow in this case needs a param to navigate from list to edit
        ChangeNotifierProvider<ValueNotifier<T>>(
            create: (_) => ValueNotifier<T>(null), child: super.widget);
  }
}