import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/list.dart';
import 'package:naples/load.dart';
import 'package:navy/navy.dart';

class ExpandableList<T> extends StatelessWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String>? itemSubtitle;
  final FunctionOf1<T, Widget>? itemLeading;
  final FunctionOf1<T, Widget>? itemTrailing;
  final FunctionOf1<T, Future<void>>? select;
  final FunctionOf0<Future<void>>? create;
  final double expandedHeight;

  ExpandableList({
    Key? key,
    required this.title,
    required this.getStream,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.select,
    this.create,
    this.expandedHeight = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Loading(
        child: ListLoader<T>(
          getStream: getStream,
          builder: (items) {
            return ExpansionTile(
              maintainState: true,
              collapsedBackgroundColor: Theme.of(context).colorScheme.surface,
              backgroundColor: Theme.of(context).colorScheme.surface,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title(items.length)),
                  if (create != null)
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        if (create == null) return;
                        this.create!();
                      },
                    )
                ],
              ),
              tilePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              initiallyExpanded: false,
              children: [
                SizedBox(
                  height: expandedHeight,
                  child: DynamicList<T>(
                    separated: true,
                    items: items,
                    itemTitle: itemTitle,
                    itemSubtitle: itemSubtitle,
                    itemLeading: itemLeading,
                    itemTrailing: itemTrailing,
                    select: select,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
