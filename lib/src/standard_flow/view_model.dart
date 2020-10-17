import 'package:flutter/widgets.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/standard_flow/service.dart';
import 'package:naples/src/view_models/edit/save_view_model.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:navy/navy.dart';
import 'navigation.dart';
import 'package:provider/provider.dart';

//T is the type of the model in the list
//U is the type of the model that is the key to select
class StandardListViewModel<T, U> extends StatelessWidget {
  final FunctionOf1<T, U> keySelector;
  final ListStandardService<T> listService;
  final NavigationModel<StandardFlow> navigationModel;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf2<BuildContext, int, String> title;

  StandardListViewModel(
    this.listService,
    this.navigationModel,
    this.keySelector,
    this.itemTitle, {
    this.itemSubtitle,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilteredViewModel(
      getStream: listService.list,
      itemTitle: itemTitle,
      itemSubtitle: itemSubtitle,
      select: (T itemToSelect) async {
        //Registers the value for side/next view
        final ValueNotifier<U> param = context.read<ValueNotifier<U>>();
        param.value = keySelector(itemToSelect);
        //Executes navigation to the next view
        //TODO: add an option to throw if not transitioned (on transition method)
        var transitioned = await navigationModel.transition(StandardFlow.Update);
        if (!transitioned) print('The transition has not been succesful!');
      },
      create: () async {
        var transitioned = await navigationModel.transition(StandardFlow.Create);
        if (!transitioned) print('The transition has not been succesful!');
      },
    );
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
