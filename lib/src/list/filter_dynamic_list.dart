import 'package:flutter/material.dart';
import 'package:naples/list.dart';
import 'package:navy/navy.dart';

class FilterDynamicList<T> extends StatelessWidget {
  final List<T> items;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String>? itemSubtitle;
  final ActionOf1<T>? onSelected;
  final String filterBy;

  const FilterDynamicList({
    Key? key,
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    this.onSelected,
    required this.filterBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterList<T>(
        items: items,
        getItemValue: itemTitle,
        filterBy: filterBy,
        builder: (filteredItems) {
          return DynamicList<T>(
            separated: true,
            items: filteredItems,
            itemTitle: itemTitle,
            itemSubtitle: itemSubtitle,
            select: (T itemToSelect) async {
              if (onSelected != null) onSelected!(itemToSelect);
            },
          );
        });
  }
}
