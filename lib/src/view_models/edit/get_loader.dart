import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

class GetLoader<T> extends StatefulWidget {
  final FunctionOf0<Future<T>> get;
  final FunctionOf2<T, bool, Widget> builder;

  GetLoader({
    @required this.get,
    @required this.builder,
    Key key,
  }) : super(key: key);

  @override
  GetLoaderState<T> createState() => GetLoaderState<T>();
}

class GetLoaderState<T> extends State<GetLoader<T>> {
  T _item;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      loading = true;
      var item = await widget.get();
      setState(() {
        _item = item;
      });
    } catch (e) {
      throw e;
    } finally {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_item == null) return Container();
    return widget.builder(_item, loading);
  }
}
