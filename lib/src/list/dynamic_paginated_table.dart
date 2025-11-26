import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class DynamicPaginatedTable<T> extends StatefulWidget {
  static const double paginateDataTableTitleRow = 68.0;
  static const double pagerWidgetHeight = 56;
  static const double paginateDataTableRowHeight = kMinInteractiveDimension;

  final List<DataColumn> dataColumns;
  final FunctionOf1<T, DataRow> getDataRow;
  final List<T> items;
  final double maxHeightAvailable;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ActionOf1<List<T>>? onItemsVisibleChanged;
  final double? headingRowHeight;
  final double? dataRowHeight;

  const DynamicPaginatedTable({
    super.key,
    required this.dataColumns,
    required this.getDataRow,
    required this.items,
    required this.maxHeightAvailable,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onItemsVisibleChanged,
    this.headingRowHeight,
    this.dataRowHeight,
  });

  @override
  State<DynamicPaginatedTable<T>> createState() => DynamicPaginatedTableState<T>();

  int get rowsPerPage {
    final effectiveHeadingHeight = headingRowHeight ?? paginateDataTableTitleRow;
    final effectiveRowHeight = dataRowHeight ?? paginateDataTableRowHeight;
    return (maxHeightAvailable - effectiveHeadingHeight - pagerWidgetHeight) ~/ effectiveRowHeight;
  }
}

class DynamicPaginatedTableState<T> extends State<DynamicPaginatedTable<T>> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<PaginatedDataTableState> _tableKey = GlobalKey<PaginatedDataTableState>();
  int _currentPage = 0;
  int _rowsPerPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.rowsPerPage != _rowsPerPage) {
      _rowsPerPage = widget.rowsPerPage;
      callOnItemsVisibleChanged(_currentPage, _rowsPerPage);
    }

    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          margin: EdgeInsets.zero,
        ),
      ),
      child: Scrollbar(
        controller: scrollController,
        trackVisibility: true,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: PaginatedDataTable(
          key: _tableKey,
          showCheckboxColumn: false, //Not show the selector in case we only want to navigate
          columns: widget.dataColumns,
          source: DynamicPaginatedTableSource<T>(
            items: widget.items,
            getDataRow: widget.getDataRow,
          ),
          availableRowsPerPage: [_rowsPerPage],
          rowsPerPage: _rowsPerPage,
          headingRowHeight: widget.headingRowHeight ?? DynamicPaginatedTable.paginateDataTableTitleRow,
          dataRowMaxHeight: widget.dataRowHeight ?? DynamicPaginatedTable.paginateDataTableRowHeight,
          dataRowMinHeight: widget.dataRowHeight ?? DynamicPaginatedTable.paginateDataTableRowHeight,
          showEmptyRows: false,
          showFirstLastButtons: true,
          sortColumnIndex: widget.sortColumnIndex,
          sortAscending: widget.sortAscending,
          controller: scrollController,
          onPageChanged: (int pageIndex) {
            //Based on pageIndex and rowsPerPage we can calculate the items that are shown
            setState(() {
              _currentPage = pageIndex ~/ _rowsPerPage;
            });
            callOnItemsVisibleChanged(_currentPage, _rowsPerPage);
          },
        ),
      ),
    );
  }

  void callOnItemsVisibleChanged(int pageIndex, int rowsPerPage) {
    if (widget.onItemsVisibleChanged == null) return;
    widget.onItemsVisibleChanged!(getItemsVisible());
  }

  List<T> getItemsVisible() {
    //Based on pageIndex and rowsPerPage we can calculate the items that are shown
    var from = _currentPage * _rowsPerPage;
    var to = from + _rowsPerPage;
    if (from > widget.items.length) from = widget.items.length;
    if (to > widget.items.length) to = widget.items.length;
    return widget.items.sublist(from, to);
  }
}

class DynamicPaginatedTableSource<T> extends DataTableSource {
  final List<T> items;
  final FunctionOf1<T, DataRow> getDataRow;

  DynamicPaginatedTableSource({required this.items, required this.getDataRow});

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
