import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/list.dart';
import 'package:naples/src/common/loading.dart';
import 'package:navy/navy.dart';

class ExpandableList<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;
  final FunctionOf1<T, Future<void>> select;
  final FunctionOf0<Future<void>> create;
  final double expandedHeight;

  ExpandableList({
    Key key,
    @required this.title,
    @required this.getStream,
    @required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.select,
    this.create,
    this.expandedHeight = 400,
  }) : super(key: key);

  @override
  _ExpandableListState<T> createState() => _ExpandableListState<T>();
}

class _ExpandableListState<T> extends State<ExpandableList<T>> {
  int _length = 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title(_length)),
          if (widget.create != null)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                this.widget.create();
              },
            )
        ],
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      initiallyExpanded: false,
      children: [
        SizedBox(
          height: widget.expandedHeight,
          child: Loading(
            child: ListLoader<T>(
              getStream: widget.getStream,
              builder: (items) {
                return DynamicList<T>(
                  items: items,
                  itemTitle: widget.itemTitle,
                  itemSubtitle: widget.itemSubtitle,
                  itemLeading: widget.itemLeading,
                  itemTrailing: widget.itemTrailing,
                  select: widget.select,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
