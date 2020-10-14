import 'package:flutter/widgets.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/standard_flow/service.dart';
import 'package:naples/src/view_models/edit/save_view_model.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:naples/src/view_models/list/list_view_model.dart';
import 'package:navy/navy.dart';
import 'navigation.dart';

//T is the type of the model in the list
//U is the type of the model that is the key to select
abstract class StandardListViewModel<T, U> extends FilteredViewModel<T>
    with CreateController, SelectController<T> {
  final FunctionOf1<T, U> keySelector;
  final ListStandardService<T> listService;
  final NavigationModel<StandardFlow> navigationModel;

  StandardListViewModel(
    BuildContext context,
    this.listService,
    this.navigationModel,
    this.keySelector,
    FunctionOf1<T, String> itemTitle, {
    FunctionOf1<T, String> itemSubtitle,
  }) : super(
          context,
          listService.list,
          itemTitle,
          itemSubtitle: itemSubtitle,
        );

  @override
  Future<void> select(T itemToSelect) async {
    //Registers the value for side/next view
    final ValueNotifier<U> param = getProvided();
    param.value = keySelector(itemToSelect);
    //Executes navigation to the next view
    var transitioned = await navigationModel.transition(StandardFlow.Update);
    if (!transitioned) print('The transition has not been succesful!');
  }

  @override
  Future<void> create() async {
    var transitioned = await navigationModel.transition(StandardFlow.Create);
    if (!transitioned) print('The transition has not been succesful!');
  }
}

abstract class StandardCreateViewModel<T, Create> extends SaveCancelViewModel<Create> {
  final CreateStandardService<T, Create> createService;

  StandardCreateViewModel(
    BuildContext context,
    NavigationModel<StandardFlow> navigationModel,
    this.createService,
  ) : super(
          context,
          navigationModel,
        );

  @override
  Future<Create> get() async {
    return await createService.getCreate();
  }

  @override
  Future<void> set() async {
    await createService.create(model);
  }
}

abstract class StandardUpdateViewModel<T, Get, Update> extends SaveCancelViewModel<Update> {
  final UpdateStandardService<T, Get, Update> updateService;

  StandardUpdateViewModel(
    BuildContext context,
    NavigationModel<StandardFlow> navigationModel,
    this.updateService,
  ) : super(
          context,
          navigationModel,
        );

  @override
  Future<Update> get() async {
    final ValueNotifier<Get> param = getProvided();
    return await updateService.getUpdate(param.value);
  }

  @override
  Future<void> set() async {
    await updateService.update(this.model);
  }
}
