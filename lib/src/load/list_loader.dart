import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/load.dart';
import 'package:navy/navy.dart';

class ListLoader<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<List<T>, Widget> builder;

  ListLoader({
    required this.getStream,
    required this.builder,
    Key? key,
  }) : super(key: key);

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
      print('load list_loader');
      _loading = true;
      _notifyLoading();
      await for (var m in widget.getStream()) {
        if (!mounted) break;
        setState(() {
          _items.add(m);
        });
      }
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      _notifyLoading();
    }
  }

  void _notifyLoading() {
    if (mounted) LoadingNotification(_loading).dispatch(context);
  }

  Future<void> refresh() async {
    if (_loading) return;
    setState(() {
      _items.clear();
    });
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<NeedRefreshNotification>(
      onNotification: (notification) {
        refresh();
        return true;
      },
      child: widget.builder(_items),
    );
  }
}
