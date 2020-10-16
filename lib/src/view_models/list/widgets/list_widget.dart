import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/list_view_model.dart';
import 'package:naples/src/view_models/list/widgets/async_action_icon_button.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'dynamic_list_widget.dart';
import 'package:provider/provider.dart';

class ListWidget<T> extends StatelessWidget {
  ListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ListViewModel<T>>();
    var viewModelWithCreate = getCreateController(viewModel);

    return BaseScaffoldWidget(
      child: Column(
        children: <Widget>[Expanded(child: DynamicListWidget<T>())],
      ),
      actions: <Widget>[
        AsyncActionIconButton(
          Icons.refresh,
          viewModel.refresh,
          message: (c) => "Refreshed!!",
        ),
      ],
      floatingAction: viewModelWithCreate == null
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (viewModelWithCreate != null) return;
                await viewModelWithCreate.create();
              },
              tooltip: 'New model', //TODO: Això s'hauria de parametritzar, i l'icona també?
              child: Icon(Icons.add),
            ),
      padding: 0,
    );
  }

  CreateController getCreateController(ListViewModel<T> viewModel) {
    if (viewModel is CreateController) return viewModel as CreateController;
    return null;
  }
}
