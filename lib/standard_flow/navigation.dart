import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/view_model.dart';

//Possible transition states
enum StandardFlow { List, Create, Update }

// T is the type of the param used to navigate from list to update
class ListCreateUpdateStandardNavigationModel<T> extends NavigationModel<StandardFlow> {
  final FunctionOf<ViewModel> _createCreateViewModel;
  final FunctionOf<ViewModel> _createUpdateViewModel;

  ListCreateUpdateStandardNavigationModel(FunctionOf<ViewModel> createListViewModel,
      this._createCreateViewModel, this._createUpdateViewModel)
      : super(StandardFlow.List, createListViewModel) {
    addTransition(StandardFlow.List, StandardFlow.Create, _createCreateViewModel);
    addTransition(StandardFlow.List, StandardFlow.Update, _createUpdateViewModel);
  }

  @override
  Widget get widget {
    return
        //The Navigation flow in this case needs a param to navigate from list to edit
        ChangeNotifierProvider<ValueNotifier<T>>(create: (_) => ValueNotifier<T>(null), child: super.widget);
  }
}
