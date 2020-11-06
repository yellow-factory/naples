import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

class ListLoader<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf2<List<T>, bool, Widget> builder;

  ListLoader({
    @required this.getStream,
    @required this.builder,
    Key key,
  }) : super(key: key);

  @override
  ListLoaderState<T> createState() => ListLoaderState<T>();
}

class ListLoaderState<T> extends State<ListLoader<T>> {
  final List<T> _items = new List<T>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      loading = true;
      await for (var m in widget.getStream()) {
        setState(() {
          _items.add(m);
        });
      }
    } catch (e) {
      throw e;
    } finally {
      loading = false;
    }
  }

  Future<void> refresh() async {
    _items.clear();
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_items, loading);
  }
}
