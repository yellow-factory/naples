import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/src/widgets/length.dart';
import 'package:navy/navy.dart';

/// Filter list of items, defining the value to filter with getItemValue
/// and the filter value with filterBy.
/// The value to filter is always a String filtered with the contains clause.
/// T Data type of the List to filter
class FilterList<T> extends StatelessWidget {
  final List<T> items;
  final FunctionOf1<T, String> getItemValue;
  final String filterBy;
  final FunctionOf1<List<T>, Widget> builder;

  const FilterList({
    required this.items,
    required this.builder,
    required this.getItemValue,
    required this.filterBy,
    super.key,
  });

  List<T> _filterItems(List<T> items) {
    var curatedFilterBy = filterBy.toLowerCase().trim();
    if (curatedFilterBy.isEmpty) return items;
    var predicate = _buildPredicate(curatedFilterBy);
    return items.where(predicate).toList();
  }

  bool Function(T item) _buildPredicate(String curatedFilterBy) {
    return (item) {
      if (item == null) return false;
      var itemValue = getItemValue(item);
      return itemValue.toLowerCase().trim().contains(curatedFilterBy);
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
