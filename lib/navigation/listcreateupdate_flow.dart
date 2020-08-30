import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';
import 'package:yellow_naples/view_models/view_model.dart';

//Possible transition states
enum ListCreateUpdateFlow { List, Create, Update }

class ListCreateUpdateStandardNavigationModel extends NavigationModel<ListCreateUpdateFlow> {
  final CreateViewModelFunction _createCreateViewModel;
  final CreateViewModelFunction _createUpdateViewModel;

  ListCreateUpdateStandardNavigationModel(CreateViewModelFunction createListViewModel,
      this._createCreateViewModel, this._createUpdateViewModel)
      : super(ListCreateUpdateFlow.List, createListViewModel) {
    addTransition(ListCreateUpdateFlow.List, ListCreateUpdateFlow.Create, _createCreateViewModel);
    addTransition(ListCreateUpdateFlow.List, ListCreateUpdateFlow.Update, _createUpdateViewModel);
  }

  @override
  Widget get widget {
    return
        //The Navigation flow in this case needs a param to navigate from list to edit
        ChangeNotifierProvider<UidParam>(create: (_) => UidParam(null), child: super.widget);
  }
}
