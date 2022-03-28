import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/src/load/refresh.dart';
import 'package:navy/navy.dart';
import 'loading.dart';

class GetLoader<T> extends StatefulWidget {
  final FunctionOf0<Future<T>> get;
  final FunctionOf1<T, Widget> builder;

  GetLoader({
    required this.get,
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  GetLoaderState<T> createState() => GetLoaderState<T>();
}

class GetLoaderState<T> extends State<GetLoader<T>> {
  T? _item;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      _loading = true;
      _notifyLoading();
      var item = await widget.get();
      setState(() {
        _item = item;
      });
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      _notifyLoading();
    }
  }

  void _notifyLoading() {
    LoadingNotification(_loading).dispatch(context);
  }

  Future<void> refresh() async {
    if (_loading) return;
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<RefreshNotification>(
      onNotification: (notification) {
        refresh();
        return true;
      },
      child: ifNotNullFunctionOf1(
        _item,
        (T item) => widget.builder(item),
        SizedBox(),
      ),
    );
  }
}
