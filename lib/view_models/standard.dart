import 'package:yellow_naples/navigation/listcreateupdate_flow.dart';
import 'package:yellow_naples/navigation/navigation.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/view_models/view_model.dart';

abstract class StandardListViewModel<T> extends ListViewModel<T> {
//TODO: De moment faig que el UidParam sempre contingui un String, però es podria fer més general, de T, de manera que enlloc d'emmagatzemar un String emmagatzemés un FunctionOf<T, U>

  final FunctionOf<T, String> uniqueId;

  StandardListViewModel(this.uniqueId);

  NavigationModel<ListCreateUpdateFlow> get navigationModel => getProvided();

  @override
  Future<void> select(T itemToSelect) async {
    //Registers the value for side/next view
    final UidParam param = getProvided();
    param.value = uniqueId(itemToSelect);
    //Executes navigation to the next view
    var transitioned = await navigationModel.transition(ListCreateUpdateFlow.Update);
    if (!transitioned) print('The transition has not been succesful!');
    super.select(itemToSelect);
  }

  @override
  Future<void> create() async {
    var transitioned = await navigationModel.transition(ListCreateUpdateFlow.Create);
    if (!transitioned) print('The transition has not been succesful!');
  }
}
