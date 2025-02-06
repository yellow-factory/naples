import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';
import 'package:naples/src/common/common.dart';

class _DistributionExpanded extends StatelessWidget {
  final Widget child;
  final int maxFlex;
  final EdgeInsetsGeometry? padding;
  const _DistributionExpanded({
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
      flex: flex,
      child: padding == null
          ? child
          : Padding(
              padding: padding!,
              child: child,
            ),
    );
  }
}

enum DistributionType { leftToRight, topToBottom }

class DistributionWidget extends StatelessWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final Iterable<Widget> children;
  final DistributionType distribution;
  final EdgeInsetsGeometry? childPadding;

  const DistributionWidget({
    super.key,
    required this.children,
    this.fixed = 1,
    this.maxFlex = 1,
    this.normalize = true,
    this.distribution = DistributionType.leftToRight,
    this.childPadding,
  });

  @override
  Widget build(BuildContext context) {
    final echildren = <_DistributionExpanded>[
      for (var c in children)
        _DistributionExpanded(
          maxFlex: maxFlex,
          padding: childPadding,
          child: c,
        )
    ];

    var distributed = distribution == DistributionType.leftToRight
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

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: distributed,
    );
  }
}

class _TopToBottomDistributionWidget extends StatelessWidget {
  final List<_DistributionExpanded> children;
  final int fixedWidgetsPerColumn;
  final bool normalize;
  final int maxFlex;

  const _TopToBottomDistributionWidget(this.children,
      {this.fixedWidgetsPerColumn = 1, this.maxFlex = 1, this.normalize = true});

  @override
  Widget build(BuildContext context) {
    //Calculates the minimum rows needed and the extra rows needed because of the columns constraint
    final widgetRows = List<List<_DistributionExpanded>>.generate(rows, (int index) => []);
    final currentFlexOnRow = <int, int>{};
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
    while (!_enoughRows(extraRowsAdded)) {
      extraRowsAdded++;
    }
    return extraRowsAdded;
  }

  bool _enoughRows(int extraRowsAdded) {
    var currentRow = 0;
    var extraRowsUsed = 0;
    var totalRows = fixedWidgetsPerColumn + extraRowsAdded;
    var currentFlexOnRow = <int, int>{};
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
    return distributionMap.where((element) => element.value + flex <= maxFlex).isNotEmpty;
  }
}

class _LeftToRightDistributionWidget extends StatelessWidget {
  final int fixedWidgetsPerRow;
  final int maxFlex;
  final List<_DistributionExpanded> children;
  final bool normalize;

  const _LeftToRightDistributionWidget(this.children,
      {this.fixedWidgetsPerRow = 1, this.maxFlex = 99, this.normalize = true});

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

  const _ContainerDistributionWidget(this.children, {this.normalize = true});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getRows(context));
  }

  int _flexOnRow(List<_DistributionExpanded> liste) => liste.sumOf((e) => e.flex);

  int get _maxFlex => children.map((c) => _flexOnRow(c)).max();

  Row _getRow(BuildContext context, List<_DistributionExpanded> expandable) {
    try {
      var expanded = <Widget>[];
      for (var e in expandable) {
        expanded.add(e.build(context));
      }
      if (normalize) {
        var flexOnRow = _flexOnRow(expandable);
        for (int i = flexOnRow; i < _maxFlex; i++) {
          expanded.add(const Spacer());
        }
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: expanded,
      );
    } catch (e) {
      rethrow;
    }
  }

  List<Row> _getRows(BuildContext context) =>
      children.where((e) => e.isNotEmpty).map((e) => _getRow(context, e)).toList();
}

class PlaygroundDistributionWidget extends StatefulWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final List<Widget> children;
  final DistributionType distribution;

  const PlaygroundDistributionWidget(this.children,
      {super.key,
      this.fixed = 1,
      this.maxFlex = 99,
      this.normalize = true,
      this.distribution = DistributionType.leftToRight});

  @override
  PlaygroundDistributionWidgetState createState() => PlaygroundDistributionWidgetState();
}

class PlaygroundDistributionWidgetState extends State<PlaygroundDistributionWidget> {
  late int fixed;
  late int maxFlex;
  late bool normalize;
  late List<Widget> children;
  late DistributionType distribution;

  late TextEditingController _fixedController;
  late TextEditingController _maxFlexController;

  @override
  void initState() {
    super.initState();
    fixed = widget.fixed;
    maxFlex = widget.maxFlex;
    normalize = widget.normalize;
    children = widget.children;
    distribution = widget.distribution;
    _fixedController = TextEditingController(text: fixed.toString());
    _maxFlexController = TextEditingController(text: maxFlex.toString());
  }

  @override
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
            title: const Text("Normalize"),
            subtitle:
                const Text("Enforce the form layout to create empty spaces to keep proportions"),
            value: normalize,
            onChanged: (value) => setState(() => normalize = value),
          ),
          SwitchListTile(
            title: const Text("Top to bottom distribution"),
            subtitle: const Text(
                "By default the distribution of the widgets is left to right, but you can opt in top to bottom"),
            value: distribution != DistributionType.leftToRight,
            onChanged: (value) => setState(() => value
                ? distribution = DistributionType.topToBottom
                : distribution = DistributionType.leftToRight),
          ),
          ListTile(
              title: const Text("Fixed widgets per row/column"),
              subtitle: const Text(
                  "In left to right distribution: fixed widgets per row, in top to bottom distribution: fixed widgets per column"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              trailing: SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _fixedController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (int.tryParse(value) != null) fixed = [int.parse(value), 1].max();
                      });
                    },
                  ))),
          ListTile(
              title: const Text("Max Flex"),
              subtitle: const Text(
                  "Max flex per row when summarizing the flex of the widgets in the row"),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              trailing: SizedBox(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _maxFlexController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (int.tryParse(value) != null) maxFlex = [int.parse(value), 1].max();
                      });
                    },
                  )))
        ])),
        DistributionWidget(
          fixed: fixed,
          maxFlex: maxFlex,
          distribution: distribution,
          normalize: normalize,
          children: children,
        )
      ],
    );
  }
}
