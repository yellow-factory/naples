import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  FilterList({
    @required this.items,
    @required this.builder,
    @required this.getItemValue,
    @required this.filterBy,
    Key key,
  }) : super(key: key);

  List<T> _filterItems(List<T> items) {
    if (getItemValue == null) return items;
    if (filterBy == null) return items;

    var curatedFilterBy = filterBy.toLowerCase().trim();
    if (curatedFilterBy.isEmpty) return items;

    var predicate = (item) {
      if (item == null) return false;
      var itemValue = getItemValue(item);
      if (itemValue == null) return false;
      return itemValue.toLowerCase().trim().contains(curatedFilterBy);
    };

    return items.where(predicate).toList();
  }

  @override
  Widget build(BuildContext context) {
    var fitems = _filterItems(items);
    return builder(fitems);
  }
}
