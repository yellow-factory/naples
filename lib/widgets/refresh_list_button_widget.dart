import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/models.dart';

class RefreshListButtonWidget extends StatelessWidget {
  RefreshListButtonWidget({Key key}) : super(key: key);

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
