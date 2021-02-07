import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

//TODO: Es podria generalitzar i que enlloc de ser per String fos per U

//T tipus de dades de la llista
class FilterList<T> extends StatelessWidget {
  final List<T> items;
  final FunctionOf1<T, String> filter;
  final String filterBy;
  final FunctionOf1<List<T>, Widget> builder;

  FilterList({
    @required this.items,
    @required this.builder,
    @required this.filter,
    @required this.filterBy,
    Key key,
  }) : super(key: key);

  // bool Function(T) get _filterPredicate {
  //   try {
  //     if (filterBy == null) return (x) => true;
  //     var filterByX = filterBy.toLowerCase().trim();
  //     if (filterByX.isEmpty) return (x) => true;
  //     return (x) => filter(x).toLowerCase().contains(filterByX);
  //   } on Exception catch (e) {
  //     throw e;
  //   }
  // }

  List<T> _filterItems(List<T> items) {
      if (filter == null) return items;
      if (filterBy == null) return items;
      var filterByX = filterBy.toLowerCase().trim();
      if (filterByX.isEmpty) return items;
      var predicate = (x) {
        if (x == null) return false;
        var f = filter(x) ?? "";
        return f.toLowerCase().trim().contains(filterByX);
      };
      return items.where(predicate).toList();
  }

  @override
  Widget build(BuildContext context) {
      var fitems = _filterItems(items);
      return builder(fitems);
  }
}
