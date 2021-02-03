import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/list.dart' as naples;
import 'package:naples/src/widgets/async_action_icon_button.dart';
import 'package:navy/navy.dart';

class FilteredViewModel<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;
  final FunctionOf1<T, Future<void>> select;
  final FunctionOf0<Future<void>> create;

  FilteredViewModel({
    @required this.getStream,
    @required this.itemTitle,
    this.title,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.select,
    this.create,
    Key key,
  }) : super(key: key);

  @override
  _FilteredViewModelState<T> createState() => _FilteredViewModelState<T>();
}

class _FilteredViewModelState<T> extends State<FilteredViewModel<T>> {
  GlobalKey<naples.ListViewModelState<T>> _listViewKey;
  bool _filtered = false;

  @override
  void initState() {
    super.initState();
    _listViewKey = GlobalKey();
  }

  Future<void> _togleFiltered() async {
    setState(() {
      _filtered = !_filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return naples.ListViewModel<T>(
      key: _listViewKey,
      getStream: widget.getStream,
      itemTitle: widget.itemTitle,
      itemSubtitle: widget.itemSubtitle,
      itemLeading: widget.itemLeading,
      itemTrailing: widget.itemTrailing,
      select: widget.select,
      title: widget.title,
      actions: <Widget>[
        AsyncActionIconButtonWidget(
          Icons.filter_list,
          _togleFiltered,
        ),
      ],
      header: _filtered
          ? Card(
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Filter by',
                ),
                onChanged: (value) {
                  if (_listViewKey.currentState != null) _listViewKey.currentState.filterBy(value);
                },
              ),
            )
          : null,
    );
  }
}
