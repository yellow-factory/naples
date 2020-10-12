import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:naples/models.dart';

class RefreshButtonWidget extends StatelessWidget {
  RefreshButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () async {
        await context.read<ListViewModel>().refresh();
        context.read<SnackModel>()..message = "Refreshed!!";
      },
    );
  }
}
