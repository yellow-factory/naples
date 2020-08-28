import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/view_models/view_model.dart';

//TODO: Per poder abstreure el comportament de listcreateupdate, caldrà fer les següents modificacions:
//1.-Fer que el constructor de ViewModel no tingui com a paràmetre el context, sinó que sigui un paràmetre de initialize (això farà de retruc que Navigation també pugui implementar OnTimeInitialize que haurà de tenir un paràmetre)
//2.-

//Possible transition states
// enum ListCreateUpdateTS { List, Create, Update }

// class ListCreateUpdateNavigationFlow extends NavigationFlow<ListCreateUpdateTS> {
//   final CreateViewModelFunction _createCreateViewModel;
//   final CreateViewModelFunction _createUpdateViewModel;

//   ListCreateUpdateNavigationFlow(CreateViewModelFunction createListViewModel,
//       this._createCreateViewModel, this._createUpdateViewModel)
//       : super(ListCreateUpdateTS.List, createListViewModel) {
//     addTransition(ListCreateUpdateTS.List, ListCreateUpdateTS.Create, _createCreateViewModel);
//     addTransition(ListCreateUpdateTS.List, ListCreateUpdateTS.Update, _createUpdateViewModel);
//   }
// }

// class ListCreateUpdateNavigation extends ListCreateUpdateNavigationFlow {
//   ListCreateUpdateNavigation()
//       : super((context) => ListModelViewModel(context), (context) => CreateModelRequestVM(context),
//             (context) => UpdateModelRequestVM(context));
// }

// class ListCreateUpdateNavigationModel extends NavigationModel<ListCreateUpdateTS> {
//   ListCreateUpdateNavigationModel() : super(ListCreateUpdateNavigation());

//   @override
//   Widget get widget {
//     return MultiProvider(providers: [
//       //The Navigation flow in this case needs a param to navigate from list to edit
//       ChangeNotifierProvider<UidParam>(create: (_) => UidParam(null)),
//     ], child: NavigationModel<ListCreateUpdateTS>(ListCreateUpdateNavigation()).widget);
//   }
// }
