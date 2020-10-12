import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:naples/widgets/snack_widget.dart';
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

    return BaseScaffoldWidget(
      child: SnackModelWidget(
          child: Column(
        children: <Widget>[FilterWidget(), Expanded(child: DynamicListWidget<T>())],
      )),
      actions: <Widget>[
        FilterButtonWidget(),
        RefreshButtonWidget(),
      ],
      floatingAction: FloatingActionButton(
        onPressed: () async {
          await viewModel.create();
        },
        tooltip: 'New model', //TODO: Això s'hauria de parametritzar, i l'icona també?
        child: Icon(Icons.add),
      ),
      padding: 0,
    );
  }
}
