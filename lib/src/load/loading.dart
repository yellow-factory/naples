import 'dart:async';

import 'package:flutter/material.dart';
import 'shimmer.dart';

class LoadingNotification extends Notification {
  final bool loading;
  LoadingNotification(this.loading);
}

class LoadingNotificationBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool loading) builder;
  const LoadingNotificationBuilder({super.key, required this.builder});

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
class AbsorbPointerWhileLoading extends StatelessWidget {
  final Widget child;
  const AbsorbPointerWhileLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LoadingNotificationBuilder(
      builder: (context, loading) {
        return AbsorbPointer(absorbing: loading, child: child);
      },
    );
  }
}

enum LoadingProgressType { linear, circular, shadow }

//Use this to show a progress indicator when loading and absorb pointer events
class LoadingProgress extends StatelessWidget {
  final Widget child;
  final LoadingProgressType type;
  const LoadingProgress({super.key, required this.child, this.type = LoadingProgressType.linear});

  @override
  Widget build(BuildContext context) {
    return LoadingNotificationBuilder(
      builder: (context, loading) {
        return LoadingProgressIndicator(loading: loading, type: type, child: child);
      },
    );
  }
}

class LoadingProgressIndicator extends StatelessWidget {
  final Widget child;
  final LoadingProgressType type;
  final bool loading;
  const LoadingProgressIndicator({
    super.key,
    required this.loading,
    required this.child,
    this.type = LoadingProgressType.linear,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          AbsorbPointer(
            absorbing: true,
            child: Container(
              color: Colors.black.withAlpha(50),
              child:
                  type == LoadingProgressType.circular
                      ? const Center(child: CircularProgressIndicator())
                      : type == LoadingProgressType.linear
                      ? LinearProgressIndicator()
                      : BlinkingShadowIndicator(height: 24.0, borderRadius: 12.0),
            ),
          ),
      ],
    );
  }
}

class BlinkingShadowIndicator extends StatelessWidget {
  final double height;
  final double borderRadius;
  const BlinkingShadowIndicator({this.height = 100.0, this.borderRadius = 12.0, super.key});

  @override
  Widget build(BuildContext context) {
    //return Container(color: const Color.fromARGB(196, 224, 224, 224));
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: height,

        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
