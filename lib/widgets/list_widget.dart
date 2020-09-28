import 'package:flutter/material.dart';
import 'package:naples/view_models/common.dart';
import './refresh_list_button_widget.dart';
import './filter_list_button_widget.dart';
import './filter_list_widget.dart';
import './snack_widget.dart';
import './base_scaffold_widget.dart';
import './dynamic_list_widget.dart';
import 'package:provider/provider.dart';

class ListWidget extends StatelessWidget {
  ListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ListViewModel>();

    return BaseScaffoldWidget(
      child: SnackModelWidget(
          child: Column(
        children: <Widget>[FilterListWidget(), Expanded(child: DynamicListWidget())],
      )),
      actions: <Widget>[
        FilterListButtonWidget(),
        RefreshListButtonWidget(),
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
