import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class DynamicPaginatedTable<T> extends StatelessWidget {
  static const double paginateDataTableTitleRow = 68.0;
  static const double pagerWidgetHeight = 56;
  static const double paginateDataTableRowHeight = kMinInteractiveDimension;

  final List<DataColumn> dataColumns;
  final FunctionOf1<T, DataRow> getDataRow;
  final List<T> items;
  final double maxHeightAvailable;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ScrollController scrollController = ScrollController();

  DynamicPaginatedTable({
    super.key,
    required this.dataColumns,
    required this.getDataRow,
    required this.items,
    required this.maxHeightAvailable,
    this.sortColumnIndex,
    this.sortAscending = true,
  });

  @override
  Widget build(BuildContext context) {
    var rowsPerPage = (maxHeightAvailable - paginateDataTableTitleRow - pagerWidgetHeight) ~/
        paginateDataTableRowHeight;

    return PaginatedDataTable(
      showCheckboxColumn: false, //Not show the selector in case we only want to navigate
      columns: dataColumns,
      source: DynamicPaginatedTableSource<T>(
        items: items,
        getDataRow: getDataRow,
      ),
      availableRowsPerPage: [rowsPerPage],
      rowsPerPage: rowsPerPage,
      dataRowMaxHeight: paginateDataTableRowHeight,
      dataRowMinHeight: paginateDataTableRowHeight,
      showEmptyRows: false,
      showFirstLastButtons: true,
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      controller: scrollController,
    );
  }
}

class DynamicPaginatedTableSource<T> extends DataTableSource {
  final List<T> items;
  final FunctionOf1<T, DataRow> getDataRow;

  DynamicPaginatedTableSource({
    required this.items,
    required this.getDataRow,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return null;
    return getDataRow(items[index]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
