import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/load.dart';
import 'package:naples/src/widgets/length.dart';
import 'package:navy/navy.dart';

class ListLoader<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<List<T>, Widget> builder;
  final ActionOf0? onLoading; //When load is initiated
  final ActionOf1<List<T>>? onLoaded; //When load is finished

  const ListLoader({
    required this.getStream,
    required this.builder,
    this.onLoading,
    this.onLoaded,
    super.key,
  });

  @override
  ListLoaderState<T> createState() => ListLoaderState<T>();
}

class ListLoaderState<T> extends State<ListLoader<T>> {
  final _items = <T>[];
  var _loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      developer.log('load method - initiated', name: 'naples.listloader');
      _loading = true;
      _notifyLoading();
      if (widget.onLoading != null) {
        widget.onLoading!();
      }

      await for (var m in widget.getStream()) {
        // Capture the current item in a final variable so the scheduled callback
        // doesn't close over the loop variable (which would otherwise end up
        // pointing to the last value on web when all callbacks run together).
        final currentItem = m;
        // Using addPostFrameCallback instead of endOfFrame gives each iteration
        // its own callback without waiting for a shared future that completes once.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          developer.log('load method - processing item received ', name: 'naples.listloader');
          if (!mounted) return;
          setState(() {
            _items.add(currentItem);
            if (_lengthWidget != null) {
              _lengthWidget?.length.value = _items.length;
            }
          });
        });
      }

      if (widget.onLoaded != null) {
        widget.onLoaded!(_items);
      }
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
      _notifyLoading();
      developer.log('load method - finished', name: 'naples.listloader');
    }
  }

  LengthWidget? get _lengthWidget {
    if (!mounted) return null;
    return context.dependOnInheritedWidgetOfExactType<LengthWidget>();
  }

  void _notifyLoading() {
    if (mounted) LoadingNotification(_loading).dispatch(context);
  }

  Future<bool> refresh() async {
    if (_loading) return false;
    setState(() {
      _items.clear();
    });
    await load();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<RefreshNotification>(
      onNotification: (notification) {
        refresh();
        return true;
      },
      child: widget.builder(_items),
    );
  }
}
