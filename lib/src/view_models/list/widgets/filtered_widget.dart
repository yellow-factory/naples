import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:naples/src/view_models/list/list_view_model.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'refresh_button_widget.dart';
import 'filter_button_widget.dart';
import 'filter_widget.dart';
import 'dynamic_list_widget.dart';
import 'package:provider/provider.dart';

class FilteredWidget<T> extends StatelessWidget {
  FilteredWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<FilteredViewModel<T>>();
    var viewModelWithCreate = getCreateController(viewModel);

    return BaseScaffoldWidget(
      child: Column(
        children: <Widget>[FilterWidget(), Expanded(child: DynamicListWidget<T>())],
      ),
      actions: <Widget>[
        FilterButtonWidget(),
        RefreshButtonWidget(),
      ],
      floatingAction: viewModelWithCreate == null
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (viewModel is CreateController) {
                  var viewModelWithCreate = viewModel as CreateController;
                  await viewModelWithCreate.create();
                }
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
