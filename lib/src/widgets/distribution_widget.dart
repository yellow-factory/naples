import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';
import 'package:naples/src/common/common.dart';

class _DistributionExpanded extends StatelessWidget {
  final Widget child;
  final int maxFlex;
  final EdgeInsetsGeometry? padding;
  _DistributionExpanded({
    required this.child,
    required this.maxFlex,
    this.padding,
  });

  int get flex {
    if (child is Expandable) {
      var flexChild = child as Expandable;
      return [flexChild.flex, maxFlex].min();
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: padding == null
          ? child
          : Padding(
              child: child,
              padding: padding!,
            ),
      flex: flex,
    );
  }
}

enum DistributionType { LeftToRight, TopToBottom }

class DistributionWidget extends StatelessWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final Iterable<Widget> children;
  final DistributionType distribution;
  final EdgeInsetsGeometry? childPadding;

  DistributionWidget({
    Key? key,
    required this.children,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.LeftToRight,
    this.childPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final echildren = <_DistributionExpanded>[
      for (var c in children)
        _DistributionExpanded(
          child: c,
          maxFlex: maxFlex,
          padding: childPadding,
        )
    ];

    return distribution == DistributionType.LeftToRight
        ? _LeftToRightDistributionWidget(
            echildren,
            fixedWidgetsPerRow: fixed,
            maxFlex: maxFlex,
            normalize: normalize,
          )
        : _TopToBottomDistributionWidget(
            echildren,
            fixedWidgetsPerColumn: fixed,
            maxFlex: maxFlex,
            normalize: normalize,
          );
  }
}

class _TopToBottomDistributionWidget extends StatelessWidget {
  final List<_DistributionExpanded> children;
  final int fixedWidgetsPerColumn;
  final bool normalize;
  final int maxFlex;

  _TopToBottomDistributionWidget(this.children,
      {Key? key, this.fixedWidgetsPerColumn = 1, this.maxFlex = 1, this.normalize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Calculates the minimum rows needed and the extra rows needed because of the columns constraint
    final widgetRows = List<List<_DistributionExpanded>>.generate(rows, (int index) => []);
    final currentFlexOnRow = Map<int, int>();
    var currentRow = 0;
    var extraRowsUsed = 0;
    //First initialize rows
    for (int i = 0; i < rows; i++) {
      currentFlexOnRow[i] = 0;
    }
    for (var w in children) {
      if (!_anyRowWithSpace(
          currentFlexOnRow.entries
              .where((element) => element.key < fixedWidgetsPerColumn + extraRowsUsed),
          w.flex,
          maxFlex)) {
        //Adds extra row
        currentRow = fixedWidgetsPerColumn + extraRowsUsed;
        extraRowsUsed++;
      }
      //Advances to the desired row
      while (currentFlexOnRow.entries.any((x) => x.key == currentRow) &&
          currentFlexOnRow[currentRow]! + w.flex > maxFlex) {
        currentRow++;
        if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
      }
      //Counts the flex in the corresponding row
      var row = currentFlexOnRow.entries.firstWhereOrNull((x) => x.key == currentRow);
      if (row != null) {
        currentFlexOnRow[currentRow] = row.value + w.flex;
      }
      widgetRows[currentRow].add(w);
      //Next row
      currentRow++;
      if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
    }
    return _ContainerDistributionWidget(widgetRows, normalize: normalize);
  }

  int get rows => fixedWidgetsPerColumn + extraRows;

  int get extraRows {
    var extraRowsAdded = 0;
    while (!_enoughRows(extraRowsAdded)) extraRowsAdded++;
    return extraRowsAdded;
  }

  bool _enoughRows(int extraRowsAdded) {
    var currentRow = 0;
    var extraRowsUsed = 0;
    var totalRows = fixedWidgetsPerColumn + extraRowsAdded;
    var currentFlexOnRow = Map<int, int>();
    //First initialize rows
    for (int i = 0; i < totalRows; i++) {
      currentFlexOnRow[i] = 0;
    }
    for (var c in children) {
      //Tops the flex value with the maxFlex
      if (!_anyRowWithSpace(
          currentFlexOnRow.entries
              .where((element) => element.key < fixedWidgetsPerColumn + extraRowsUsed),
          c.flex,
          maxFlex)) {
        if (extraRowsUsed == extraRowsAdded) return false;
        //Adds extra row
        currentRow = fixedWidgetsPerColumn + extraRowsUsed;
        extraRowsUsed++;
      }
      //Advances to the desired row
      while (currentFlexOnRow.entries.any((x) => x.key == currentRow) &&
          currentFlexOnRow[currentRow]! + c.flex > maxFlex) {
        currentRow++;
        if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
      }
      //Counts the flex in the corresponding row
      var row = currentFlexOnRow.entries.firstWhereOrNull((x) => x.key == currentRow);
      if (row != null) {
        currentFlexOnRow[currentRow] = row.value + c.flex;
      }
      //Next row
      currentRow++;
      if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
    }
    return true;
  }

  bool _anyRowWithSpace(Iterable<MapEntry<int, int>> distributionMap, int flex, int maxFlex) {
    return distributionMap.where((element) => element.value + flex <= maxFlex).length > 0;
  }
}

class _LeftToRightDistributionWidget extends StatelessWidget {
  final int fixedWidgetsPerRow;
  final int maxFlex;
  final List<_DistributionExpanded> children;
  final bool normalize;

  _LeftToRightDistributionWidget(this.children,
      {Key? key, this.fixedWidgetsPerRow = 1, this.maxFlex = 99, this.normalize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //The number of columns is fixed...
    final widgetRows = <List<_DistributionExpanded>>[[]]; //List of all rows, initialize first row
    int currentRow = 0;
    int flexOnRow = 0; //Sum flex of widgets on the current row
    int columnCount = 1;
    for (var w in children) {
      var currentFlex = flexOnRow + w.flex;
      var row = widgetRows[currentRow];
      if (currentFlex < maxFlex && columnCount < fixedWidgetsPerRow) {
        //Adds the widget to the current row of widgets
        row.add(w);
        flexOnRow += w.flex;
        columnCount++;
        continue;
      }
      if (currentFlex <= maxFlex && columnCount <= fixedWidgetsPerRow) {
        row.add(w);
        //Initialize row values
        flexOnRow = 0;
        columnCount = 1;
        currentRow++;
        widgetRows.add([]);
        continue;
      }
      //If the new widget has a flex that overflows current row
      currentRow++;
      columnCount = 1;
      widgetRows.add([]);
      widgetRows[currentRow].add(w);
      flexOnRow = w.flex;
    }
    return _ContainerDistributionWidget(widgetRows, normalize: normalize);
  }
}

class _ContainerDistributionWidget extends StatelessWidget {
  final List<List<_DistributionExpanded>> children;
  final bool normalize;

  _ContainerDistributionWidget(this.children, {Key? key, this.normalize = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getRows(context));
  }

  int _flexOnRow(List<_DistributionExpanded> liste) => liste.sumOf((e) => e.flex);

  int get _maxFlex => children.map((c) => _flexOnRow(c)).max();

  Row _getRow(BuildContext context, List<_DistributionExpanded> expandable) {
    try {
      var expanded = <Widget>[];
      for (var e in expandable) expanded.add(e.build(context));
      if (normalize) {
        var flexOnRow = _flexOnRow(expandable);
        for (int i = flexOnRow; i < _maxFlex; i++) {
          expanded.add(Spacer());
        }
      }
      return Row(
        children: expanded,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
      );
    } catch (e) {
      throw e;
    }
  }

  List<Row> _getRows(BuildContext context) =>
      children.where((e) => e.length > 0).map((e) => _getRow(context, e)).toList();
}

class PlaygroundDistributionWidget extends StatefulWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final List<Widget> children;
  final DistributionType distribution;

  PlaygroundDistributionWidget(this.children,
      {Key? key,
      this.fixed = 1,
      this.maxFlex = 99,
      this.normalize = true,
      this.distribution = DistributionType.LeftToRight})
      : super(key: key);

  @override
  _PlaygroundDistributionWidgetState createState() =>
      _PlaygroundDistributionWidgetState(fixed, maxFlex, normalize, children, distribution);
}

class _PlaygroundDistributionWidgetState extends State<PlaygroundDistributionWidget> {
  int fixed;
  int maxFlex;
  bool normalize;
  List<Widget> children;
  DistributionType distribution;

  _PlaygroundDistributionWidgetState(
      this.fixed, this.maxFlex, this.normalize, this.children, this.distribution);

  late TextEditingController _fixedController;
  late TextEditingController _maxFlexController;

  void initState() {
    super.initState();
    _fixedController = TextEditingController(text: fixed.toString());
    _maxFlexController = TextEditingController(text: maxFlex.toString());
  }

  void dispose() {
    _fixedController.dispose();
    _maxFlexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Column(children: [
          SwitchListTile(
            title: Text("Normalize"),
            subtitle: Text("Enforce the form layout to create empty spaces to keep proportions"),
            value: normalize,
            onChanged: (value) => setState(() => normalize = value),
          ),
          SwitchListTile(
            title: Text("Top to bottom distribution"),
            subtitle: Text(
                "By default the distribution of the widgets is left to right, but you can opt in top to bottom"),
            value: distribution != DistributionType.LeftToRight,
            onChanged: (value) => setState(() => value
                ? distribution = DistributionType.TopToBottom
                : distribution = DistributionType.LeftToRight),
          ),
          new ListTile(
              title: Text("Fixed widgets per row/column"),
              subtitle: Text(
                  "In left to right distribution: fixed widgets per row, in top to bottom distribution: fixed widgets per column"),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              trailing: new Container(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _fixedController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        if (int.tryParse(value) != null) fixed = [int.parse(value), 1].max();
                      });
                    },
                  ))),
          new ListTile(
              title: Text("Max Flex"),
              subtitle:
                  Text("Max flex per row when summarizing the flex of the widgets in the row"),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              trailing: new Container(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _maxFlexController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        if (int.tryParse(value) != null) maxFlex = [int.parse(value), 1].max();
                      });
                    },
                  )))
        ])),
        DistributionWidget(
          children: children,
          fixed: fixed,
          maxFlex: maxFlex,
          distribution: distribution,
          normalize: normalize,
        )
      ],
    );
  }
}
