import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';
import 'package:provider/single_child_widget.dart';

class Loading extends SingleChildStatefulWidget {
  const Loading({Key? key, required Widget? child}) : super(key: key, child: child);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends SingleChildState<Loading> {
  bool _loading = false;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ifNotNullFunctionOf1(
      child,
      (Widget c) {
        return NotificationListener<LoadingNotification>(
            onNotification: (notification) {
              scheduleMicrotask(() {
                setState(() {
                  _loading = notification.loading;
                });
              });
              return true;
            },
            child: Column(
              children: [
                if (_loading) LinearProgressIndicator(),
                Expanded(child: c),
              ],
            ));
      },
      SizedBox(),
    );
  }
}

class LoadingNotification extends Notification {
  final bool loading;
  LoadingNotification(this.loading);
}
