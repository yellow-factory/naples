import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/src/widgets/length.dart';
import 'package:navy/navy.dart';

/// Filter list of items, with a predicate: filterBy
/// T Data type of the List to filter
class FilterList<T> extends StatelessWidget {
  final List<T> items;
  final PredicateOf1<T> filterBy;
  final FunctionOf1<List<T>, Widget> builder;

  const FilterList({
    required this.items,
    required this.builder,
    required this.filterBy,
    super.key,
  });

  List<T> _filterItems(List<T> items) {
    var predicate = _buildPredicate();
    return items.where(predicate).toList();
  }

  bool Function(T item) _buildPredicate() {
    return (item) {
      if (item == null) return false;
      return filterBy(item);
    };
  }

  @override
  Widget build(BuildContext context) {
    var fitems = _filterItems(items);
    var lengthWidget = context.dependOnInheritedWidgetOfExactType<LengthWidget>();
    if (lengthWidget != null) {
      scheduleMicrotask(() => lengthWidget.length.value = fitems.length);
    }
    return builder(fitems);
  }
}
