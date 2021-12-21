import 'dart:async';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final Widget child;
  const Loading({Key? key, required this.child}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<LoadingNotification>(
      onNotification: (notification) {
        if (_loading == notification.loading) return true;
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
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class LoadingNotification extends Notification {
  final bool loading;
  LoadingNotification(this.loading);
}
