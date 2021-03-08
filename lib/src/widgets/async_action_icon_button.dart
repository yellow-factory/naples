import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class AsyncActionIconButtonWidget extends StatelessWidget {
  final IconData iconData;
  final FunctionOf0<Future<void>>? action;
  final String? message;

  AsyncActionIconButtonWidget({
    required this.iconData,
    this.action,
    this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: () async {
        if (action == null) return;
        await action!();
        if (message == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message!),
          ),
        );
      },
    );
  }
}
