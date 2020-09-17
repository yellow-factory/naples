import 'package:flutter/material.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class DynamicFormWidget extends StatelessWidget {
  int columns = 1;
  int rows = 1;
  bool normalize = true;
  FunctionOf1<List<Expanded>, List<List<Widget>>> _distributeWidgets;

  DynamicFormWidget({Key key}) : super(key: key) {
    //Defaults to fix 1 column
    columns = 1;
    _distributeWidgets = _distributeLeftToRight;
  }

  DynamicFormWidget.fixColumns({Key key, this.columns = 1, this.normalize}) : super(key: key) {
    _distributeWidgets = _distributeLeftToRight;
  }

  DynamicFormWidget.fixRows({Key key, this.rows = 1, this.normalize}) : super(key: key) {
    _distributeWidgets = _distributeTopToBottom;
  }

  @override
  Widget build(BuildContext context) {
    // var properties =
    //     context.select<GetSetViewModel, Iterable<EditableViewModelProperty>>((x) => x.properties);

//TODO: Estudiar si ha de dependre de GetSetViewModel o ha de ser independent. Potser el mapeig de
//widgets es podria fer al control que el conté i aquest es podria aprofitar per altres coses?

    final getSetViewModel = context.watch<GetSetViewModel>();
    final expandedWidgets =
        getSetViewModel.properties.map((e) => _getExpanded(e.widget, e.flex)).toList();
    final distributedWidgets = _distributeWidgets(expandedWidgets);

    //Return a Form with all the widgets
    var rows = distributedWidgets.map((e) => _getRow(e)).toList();
    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
      autovalidate: true,
    );
  }

  List<List<Widget>> _distributeLeftToRight(List<Expanded> widgets) {
    //The number of columns is fixed...
    final widgetRows = <List<Expanded>>[List<Expanded>()]; //List of all rows, initialize first row
    int currentRow = 0;
    int flexOnRow = 0; //Sum flex of widgets on the current row
    for (var widget in widgets) {
      var row = widgetRows[currentRow];
      if (flexOnRow + widget.flex < columns) {
        //Adds the widget to the current row of widgets
        row.add(widget);
        flexOnRow += widget.flex;
        continue;
      }
      if (flexOnRow + widget.flex == columns) {
        row.add(widget);
        //Initialize row values
        flexOnRow = 0;
        currentRow++;
        widgetRows.add(List<Expanded>());
        continue;
      }
      //If the new widget has a flex that overflows current row
      if (flexOnRow + widget.flex > columns) {
        currentRow++;
        widgetRows.add(List<Expanded>());
        widgetRows[currentRow].add(widget);
        flexOnRow = widget.flex;
      }
    }

    //Normalize Rows
    _normalizeRows(widgetRows);

    return widgetRows;
  }

  //TODO: Normalization of the rows may be an optional?

  List<List<Widget>> _distributeTopToBottom(List<Expanded> widgets) {
    //In this case the number of rows is fixed...

    //List of all rows
    final widgetRows = List<List<Expanded>>.generate(rows, (int index) => List<Expanded>());
    var currentRow = PrimitiveWrapper<int>(0);
    var currentColumn = PrimitiveWrapper<int>(0);
    for (var widget in widgets) {
      print('column: ${currentColumn.value}');
      print('row: ${currentRow.value}');
      var row = _getNextRow(widgetRows, currentRow, currentColumn);
      row.add(widget);
    }

    //Normalize Rows
    _normalizeRows(widgetRows);

    return widgetRows;
  }

  void _normalizeRows(List<List<Expanded>> widgetRows) {
    if (!normalize) return;
    if (widgetRows.length == 0) return;
    var maxFlex = widgetRows
        .map((e) => _flexOnRow(e))
        .reduce((value, element) => [value, element].fold(0, max));
    for (var row in widgetRows) {
      var flexOnRow = _flexOnRow(row);
      while (flexOnRow < maxFlex) {
        row.add(_getExpanded(Container(), 1));
        flexOnRow++;
      }
    }
  }

  List<Expanded> _getNextRow(List<List<Expanded>> widgetRows, PrimitiveWrapper<int> currentRow,
      PrimitiveWrapper<int> currentColumn) {
    //If necessary returns to the first row and changes column
    if (currentRow.value >= rows) {
      print("newcolumn");
      currentRow.value = 0;
      currentColumn.value++;
    }
    var row = widgetRows[currentRow.value];
    var flexOnRow = _flexOnRow(row);
    ++currentRow.value;
    if (flexOnRow <= currentColumn.value) {
      return row;
    }

    return _getNextRow(widgetRows, currentRow, currentColumn);
  }

  int _flexOnRow(List<Expanded> widgets) => widgets.length == 0
      ? 0
      : widgets.map((e) => e.flex).reduce((value, element) => value + element);

  Expanded _getExpanded(Widget widget, int flex) {
    return Expanded(
        child: Container(child: widget, margin: EdgeInsets.symmetric(vertical: 2, horizontal: 3)),
        flex: flex ?? 1);
  }

  Row _getRow(List<Widget> widgets) {
    return Row(
      children: widgets,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
    );
  }
}
