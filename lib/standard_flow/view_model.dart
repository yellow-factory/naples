import 'package:flutter/widgets.dart';
import 'package:yellow_naples/navigation/navigation.dart';
import 'package:yellow_naples/standard_flow/service.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'navigation.dart';

//T is the type of the model in the list
//U is the type of the model that is the key to select
abstract class StandardListViewModel<T, U> extends ListViewModel<T> {
  final FunctionOf1<T, U> keySelector;
  ListStandardService<T> _listService;

  StandardListViewModel(this.keySelector);

  @override
  Future<void> init1(BuildContext context) async {
    this.context = context;
    _listService = getProvided();
    super.init1(context);
  }

  @override
  Stream<T> getStream() => _listService.list();

  NavigationModel<ListCreateUpdateFlow> get navigationModel => getProvided();

  @override
  Future<void> select(T itemToSelect) async {
    //Registers the value for side/next view
    final Param<U> param = getProvided();
    param.value = keySelector(itemToSelect);
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

abstract class StandardCreateViewModel<T, Create> extends SaveCancelViewModel<Create> {
  CreateStandardService<T, Create> _createService;

  @override
  Future<void> init1(BuildContext context) async {
    this.context = context;
    _createService = getProvided();
    super.init1(context);
  }

  @override
  Future<Create> get() async {
    return await _createService.getCreate();
  }

  @override
  Future<void> set() async {
    await _createService.create(model);
  }
}

abstract class StandardUpdateViewModel<T, Get, Update> extends SaveCancelViewModel<Update> {
  UpdateStandardService<T, Get, Update> _updateService;

  @override
  Future<void> init1(BuildContext context) async {
    this.context = context;
    _updateService = getProvided();
    super.init1(context);
  }

  @override
  Future<Update> get() async {
    final Param<Get> param = getProvided();
    return await _updateService.getUpdate(param.value);
  }

  @override
  Future<void> set() async {
    await _updateService.update(this.model);
  }
}
