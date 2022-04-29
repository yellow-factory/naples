import 'dart:async';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final Widget child;
  final bool keepSpace;
  const Loading({Key? key, required this.child, this.keepSpace = true}) : super(key: key);

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
          _loading ? LinearProgressIndicator() : SizedBox(height: widget.keepSpace ? 4 : 0),
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
