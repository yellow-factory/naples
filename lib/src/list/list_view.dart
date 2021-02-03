import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/list.dart';
import 'package:naples/src/common/loading.dart';
import 'package:naples/src/list/list_loader.dart';
import 'package:navy/navy.dart';

//T tipus de dades de la llista
//ListView= ListLoader + DynamicList
class ListView<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;
  final FunctionOf1<T, Future<void>> select;
  final Widget header;

  ListView({
    @required this.getStream,
    @required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.header,
    this.title,
    this.select,
    Key key,
  }) : super(key: key);

  @override
  ListViewState<T> createState() => ListViewState<T>();
}

class ListViewState<T> extends State<ListView<T>> {
  GlobalKey<ListLoaderState<T>> _listLoaderKey;
  String filterValue = "";

  @override
  void initState() {
    super.initState();
    _listLoaderKey = GlobalKey();
  }

  bool Function(T) get _filterPredicate {
    var filterBy = filterValue.toLowerCase().trim();
    if (filterBy.isEmpty) return (x) => true;
    return (x) => widget.itemTitle(x).toLowerCase().contains(filterBy);
  }

  List<T> _filteredItems(List<T> items) {
    var lst = items.where(_filterPredicate).toList();
    LengthNotification(lst.length).dispatch(context);
    return lst;
  }

  void refresh() {
    _listLoaderKey.currentState.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ListLoader<T>(
      key: _listLoaderKey,
      getStream: widget.getStream,
      builder: (items, loading) {
        return Column(
          children: <Widget>[
            if (widget.header != null) widget.header,
            Expanded(
              child: DynamicList<T>(
                items: _filteredItems(items),
                itemTitle: widget.itemTitle,
                itemSubtitle: widget.itemSubtitle,
                itemLeading: widget.itemLeading,
                itemTrailing: widget.itemTrailing,
                select: widget.select,
              ),
            ),
          ],
        );
      },
    );
  }
}

class LengthNotification extends Notification {
  final int length;
  LengthNotification(this.length);
}
