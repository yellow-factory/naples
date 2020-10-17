import 'package:flutter/material.dart';
import 'package:naples/models.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class AsyncActionIconButton extends StatelessWidget {
  final IconData iconData;
  final FunctionOf0<Future<void>> action;
  final FunctionOf1<BuildContext, String> message;

  AsyncActionIconButton(
    this.iconData,
    this.action, {
    this.message,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: () async {
        await action();
        if (message != null) {
          context.read<SnackModel>()..message = message(context);
        }
      },
    );
  }
}
