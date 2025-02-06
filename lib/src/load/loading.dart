import 'dart:async';

import 'package:flutter/material.dart';

class LoadingNotification extends Notification {
  final bool loading;
  LoadingNotification(this.loading);
}

class LoadingNotificationBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool loading) builder;
  const LoadingNotificationBuilder({
    super.key,
    required this.builder,
  });

  @override
  State<LoadingNotificationBuilder> createState() => _LoadingNotificationBuilderState();
}

class _LoadingNotificationBuilderState extends State<LoadingNotificationBuilder> {
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
      child: widget.builder(context, _loading),
    );
  }
}

//Use this to absorb pointer events when loading
class Loading extends StatelessWidget {
  final Widget child;
  const Loading({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingNotificationBuilder(
      builder: (context, loading) {
        return AbsorbPointer(
          absorbing: loading,
          child: child,
        );
      },
    );
  }
}

enum LoadingProgressType {
  linear,
  circular,
}

//Use this to show a progress indicator when loading and absorb pointer events
class LoadingProgress extends StatelessWidget {
  final Widget child;
  final LoadingProgressType type;
  const LoadingProgress({
    super.key,
    required this.child,
    this.type = LoadingProgressType.linear,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingNotificationBuilder(
      builder: (context, loading) {
        return Stack(
          children: [
            child,
            if (loading)
              AbsorbPointer(
                absorbing: true,
                child: Container(
                    color: Colors.white.withOpacity(0.5),
                    child: type == LoadingProgressType.circular
                        ? const Center(child: CircularProgressIndicator())
                        : const LinearProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
