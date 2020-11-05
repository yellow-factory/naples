import 'package:flutter/widgets.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/standard_flow/service.dart';
import 'package:naples/src/view_models/edit/save_view_model.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:naples/widgets/distribution_widget.dart';
import 'package:navy/navy.dart';
import 'navigation.dart';
import 'package:provider/provider.dart';

//T is the type of the model in the list
//U is the type of the model that is the key to select
class StandardListViewModel<T, U> extends StatelessWidget {
  final FunctionOf1<T, U> keySelector;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<int, String> title;

  StandardListViewModel({
    @required this.keySelector,
    this.itemTitle,
    this.itemSubtitle,
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listService = context.watch<ListStandardService<T>>();
    var navigationModel = context.watch<NavigationModel<StandardFlow>>();
    return FilteredViewModel(
      title: title,
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

class StandardCreateViewModel<T, Create> extends StatelessWidget {
  final FunctionOf1<Create, String> title;
  final FunctionOf1<Create, Iterable<Widget>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  StandardCreateViewModel({
    this.title,
    this.getLayoutMembers,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution,
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    var createService = context.watch<CreateStandardService<T, Create>>();
    var navigationModel = context.watch<NavigationModel<StandardFlow>>();
    return SaveCancelViewModel<Create>(
      get: createService.getCreate,
      set: (m) async {
        await createService.create(m);
      },
      getLayoutMembers: getLayoutMembers,
      fixed: fixed,
      maxFlex: maxFlex,
      normalize: normalize,
      distribution: distribution,
      navigationModel: navigationModel,
    );
  }
}

class StandardUpdateViewModel<T, Get, Update> extends StatelessWidget {
  final FunctionOf1<Update, String> title;
  final FunctionOf1<Update, Iterable<Widget>> getLayoutMembers;
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final DistributionType distribution;

  StandardUpdateViewModel({
    this.title,
    this.getLayoutMembers,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var updateService = context.watch<UpdateStandardService<T, Get, Update>>();
    var navigationModel = context.watch<NavigationModel<StandardFlow>>();
    return SaveCancelViewModel<Update>(
      title: title,
      get: () async {
        final ValueNotifier<Get> param = Provider.of<ValueNotifier<Get>>(context);
        return await updateService.getUpdate(param.value);
      },
      set: (m) async {
        await updateService.update(m);
      },
      getLayoutMembers: getLayoutMembers,
      fixed: fixed,
      maxFlex: maxFlex,
      normalize: normalize,
      distribution: distribution,
      navigationModel: navigationModel,
    );
  }
}
