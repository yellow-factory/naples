import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';

//Possible transition states
enum StandardFlow { List, Create, Update }

// T is the type of the param used to navigate from list to update
class ListCreateUpdateStandardNavigationModel extends NavigationModel<StandardFlow> {
  final FunctionOf0<StateViewModel<StandardFlow>> _createCreateViewModel;
  final FunctionOf0<StateViewModel<StandardFlow>> _createUpdateViewModel;

  ListCreateUpdateStandardNavigationModel(
    FunctionOf0<StateViewModel<StandardFlow>> createListViewModel,
    this._createCreateViewModel,
    this._createUpdateViewModel,
  ) : super(
          createListViewModel,
        ) {
    addTransition(StandardFlow.List, StandardFlow.Create, _createCreateViewModel);
    addTransition(StandardFlow.List, StandardFlow.Update, _createUpdateViewModel);
  }
}
