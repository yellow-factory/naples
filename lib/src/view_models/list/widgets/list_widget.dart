import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/list_view_model.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'refresh_button_widget.dart';
import 'dynamic_list_widget.dart';
import 'package:provider/provider.dart';

class ListWidget<T> extends StatelessWidget {
  ListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ListViewModel<T>>();

    return BaseScaffoldWidget(
      child: Column(
        children: <Widget>[Expanded(child: DynamicListWidget<T>())],
      ),
      actions: <Widget>[
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
