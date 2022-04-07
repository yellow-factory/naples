import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class DynamicTable<T> extends StatelessWidget {
  final List<DataColumn> dataColumns;
  final FunctionOf1<T, DataRow> getDataRow;
  final List<T> items;

  const DynamicTable({
    Key? key,
    required this.dataColumns,
    required this.getDataRow,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false, //Not show the selector in case we only want to navigate
      columns: dataColumns,
      rows: <DataRow>[for (var x in items) getDataRow(x)],
    );
  }
}
