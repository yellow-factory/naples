import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class DynamicPaginatedTable<T> extends StatefulWidget {
  static const double paginateDataTableTitleRow = 68.0;
  static const double pagerWidgetHeight = 56;
  static const double paginateDataTableRowHeight = kMinInteractiveDimension;

  final List<DataColumn> dataColumns;
  final FunctionOf2<int, T, DataRow> getDataRow;
  final List<T> items;
  final double maxHeightAvailable;
  final int? sortColumnIndex;
  final bool sortAscending;
  final ActionOf1<List<T>>? onItemsVisibleChanged;
  final Future<void> Function()? onNeedLoadData;
  final double? headingRowHeight;
  final double? dataRowHeight;
  final int? totalCount; // Total count of items, even if not all are loaded

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
    this.totalCount,
    this.onNeedLoadData,
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
  late final DynamicPaginatedTableSource<T> _tableSource;
  bool _loading = false;
  int _loadUntil = 0;

  @override
  void initState() {
    super.initState();
    _loadUntil = widget.items.length;
    _tableSource = DynamicPaginatedTableSource<T>(
      items: widget.items,
      columns: widget.dataColumns,
      getDataRow: widget.getDataRow,
      totalCount: widget.totalCount,
    );
  }

  @override
  void didUpdateWidget(covariant DynamicPaginatedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the number of columns has changed
    bool columnsChanged = widget.dataColumns.length != oldWidget.dataColumns.length;

    // Update the data source when items or totalCount change
    if (widget.items != oldWidget.items ||
        widget.totalCount != oldWidget.totalCount ||
        columnsChanged) {
      _tableSource.updateData(widget.items, widget.totalCount, widget.dataColumns, notify: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rowsPerPage != _rowsPerPage) {
      _rowsPerPage = widget.rowsPerPage;
      callOnItemsVisibleChanged();
    }

    if (_loading) return Center(child: CircularProgressIndicator());

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
          source: _tableSource,
          availableRowsPerPage: [_rowsPerPage],
          initialFirstRowIndex: _currentPage * _rowsPerPage,
          rowsPerPage: _rowsPerPage,
          headingRowHeight:
              widget.headingRowHeight ?? DynamicPaginatedTable.paginateDataTableTitleRow,
          dataRowMaxHeight:
              widget.dataRowHeight ?? DynamicPaginatedTable.paginateDataTableRowHeight,
          dataRowMinHeight:
              widget.dataRowHeight ?? DynamicPaginatedTable.paginateDataTableRowHeight,
          showEmptyRows: false,
          showFirstLastButtons: true,
          sortColumnIndex: widget.sortColumnIndex,
          sortAscending: widget.sortAscending,
          controller: scrollController,
          onPageChanged: (int firstRowIndexCurrentPage) {
            //Based on firstRowIndexCurrentPage and rowsPerPage we can calculate the page index
            setState(() {
              _currentPage = firstRowIndexCurrentPage ~/ _rowsPerPage;
            });
            _updateLoadUntil();

            // Load more data proactively if we're near the end
            _loadMoreDataIfNeeded();

            callOnItemsVisibleChanged();
          },
        ),
      ),
    );
  }

  void _updateLoadUntil() {
    // Calculate how many items we need for the next page
    var nextPageStart = (_currentPage) * _rowsPerPage;
    var nextPageEnd = nextPageStart + _rowsPerPage;
    if (nextPageEnd > _loadUntil) {
      if (widget.totalCount != null && nextPageEnd > widget.totalCount!) {
        _loadUntil = widget.totalCount!;
      } else {
        _loadUntil = nextPageEnd;
      }
    }
  }

  // Load more data proactively if we're near the end of loaded items
  Future<void> _loadMoreDataIfNeeded() async {
    try {
      if (_loading) return;
      _loading = true;

      if (widget.onNeedLoadData == null) return;

      // Check if we've already loaded all data
      if (widget.totalCount != null && widget.items.length >= widget.totalCount!) {
        return; // No more items to load
      }

      // If we don't have enough items for the next page, load more
      while (_loadUntil > widget.items.length) {
        await widget.onNeedLoadData!();
        _tableSource.updateData(widget.items, widget.totalCount, widget.dataColumns, notify: true);
      }
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
    }
  }

  void callOnItemsVisibleChanged() {
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
  List<T> items;
  List<DataColumn> columns;
  final FunctionOf2<int, T, DataRow> getDataRow;
  int? totalCount;

  DynamicPaginatedTableSource({
    required this.items,
    required this.columns,
    required this.getDataRow,
    this.totalCount,
  });

  void updateData(
    List<T> newItems,
    int? newTotalCount,
    List<DataColumn> newColumns, {
    bool notify = true,
  }) {
    items = newItems;
    totalCount = newTotalCount;
    columns = newColumns;
    if (notify) {
      notifyListeners();
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return _getBlankRowFor(index);
    return getDataRow(index, items[index]);
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: columns.map<DataCell>((DataColumn column) => DataCell.empty).toList(),
    );
  }

  @override
  bool get isRowCountApproximate => false;
  //When isRowCountApproximate = true does not show the circular progress indicator, but has other side effects

  @override
  int get rowCount {
    return totalCount ?? items.length;
  }

  @override
  int get selectedRowCount => 0;
}
