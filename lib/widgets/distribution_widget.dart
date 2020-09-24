import 'package:flutter/material.dart';
import 'package:list_ext/list_ext.dart';

class Expandable {
  final Widget child;
  final int flex;
  Expandable(this.child, this.flex);
}

enum DistributionType { LeftToRight, TopToBottom }

class DistributionWidget extends StatelessWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final List<Expandable> children;
  final DistributionType distribution;

  DistributionWidget(this.children,
      {Key key,
      this.fixed = 1,
      this.maxFlex = 1,
      this.normalize = true,
      this.distribution = DistributionType.LeftToRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return distribution == DistributionType.LeftToRight
        ? LeftToRightDistributionWidget(children,
            fixedWidgetsPerRow: fixed, maxFlex: maxFlex, normalize: normalize)
        : TopToBottomDistributionWidget(children,
            fixedWidgetsPerColumn: fixed, maxFlex: maxFlex, normalize: normalize);
  }
}

class TopToBottomDistributionWidget extends StatelessWidget {
  final List<Expandable> children;
  final int fixedWidgetsPerColumn;
  final bool normalize;
  final int maxFlex;

  TopToBottomDistributionWidget(this.children,
      {Key key, this.fixedWidgetsPerColumn = 1, this.maxFlex = 1, this.normalize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Calculates the minimum rows needed and the extra rows needed because of the columns constraint
    final widgetRows = List<List<Expandable>>.generate(rows, (int index) => List<Expandable>());
    final currentFlexOnRow = Map<int, int>();
    var currentRow = 0;
    var extraRowsUsed = 0;
    //First initialize rows
    for (int i = 0; i < rows; i++) {
      currentFlexOnRow[i] = 0;
    }
    for (var w in children) {
      var currentFlex = [w.flex, maxFlex].min();
      var currentExpandable = new Expandable(w.child, currentFlex);
      if (!_anyRowWithSpace(
          currentFlexOnRow.entries
              .where((element) => element.key < fixedWidgetsPerColumn + extraRowsUsed),
          currentFlex,
          maxFlex)) {
        //Adds extra row
        currentRow = fixedWidgetsPerColumn + extraRowsUsed;
        extraRowsUsed++;
      }
      //Advances to the desired row
      while (currentFlexOnRow[currentRow] + currentFlex > maxFlex) {
        currentRow++;
        if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
      }
      //Counts the flex in the corresponding row
      currentFlexOnRow[currentRow] += currentFlex;
      widgetRows[currentRow].add(currentExpandable);
      //Next row
      currentRow++;
      if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
    }
    return ContainerDistributionWidget(widgetRows, normalize: normalize);
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
      var currentFlex = [c.flex, maxFlex].min();
      if (!_anyRowWithSpace(
          currentFlexOnRow.entries
              .where((element) => element.key < fixedWidgetsPerColumn + extraRowsUsed),
          currentFlex,
          maxFlex)) {
        if (extraRowsUsed == extraRowsAdded) return false;
        //Adds extra row
        currentRow = fixedWidgetsPerColumn + extraRowsUsed;
        extraRowsUsed++;
      }
      //Advances to the desired row
      while (currentFlexOnRow[currentRow] + currentFlex > maxFlex) {
        currentRow++;
        if (currentRow >= fixedWidgetsPerColumn + extraRowsUsed) currentRow = 0;
      }
      //Counts the flex in the corresponding row
      currentFlexOnRow[currentRow] += currentFlex;
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

class LeftToRightDistributionWidget extends StatelessWidget {
  final int fixedWidgetsPerRow;
  final int maxFlex;
  final List<Expandable> children;
  final bool normalize;

  LeftToRightDistributionWidget(this.children,
      {Key key, this.fixedWidgetsPerRow = 1, this.maxFlex = 99, this.normalize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //The number of columns is fixed...
    final widgetRows = <List<Expandable>>[
      List<Expandable>()
    ]; //List of all rows, initialize first row
    int currentRow = 0;
    int flexOnRow = 0; //Sum flex of widgets on the current row
    int columnCount = 1;
    for (var w in children) {
      var currentExpandable = new Expandable(w.child, [w.flex, maxFlex].min());
      var currentFlex = flexOnRow + w.flex;
      var row = widgetRows[currentRow];
      if (currentFlex < maxFlex && columnCount < fixedWidgetsPerRow) {
        //Adds the widget to the current row of widgets
        row.add(currentExpandable);
        flexOnRow += currentExpandable.flex;
        columnCount++;
        continue;
      }
      if (currentFlex == maxFlex || columnCount == fixedWidgetsPerRow) {
        row.add(currentExpandable);
        //Initialize row values
        flexOnRow = 0;
        columnCount = 1;
        currentRow++;
        widgetRows.add(List<Expandable>());
        continue;
      }
      //If the new widget has a flex that overflows current row
      currentRow++;
      columnCount = 1;
      widgetRows.add(List<Expandable>());
      widgetRows[currentRow].add(currentExpandable);
      flexOnRow = currentExpandable.flex;
    }
    return ContainerDistributionWidget(widgetRows, normalize: normalize);
  }
}

class ContainerDistributionWidget extends StatelessWidget {
  final List<List<Expandable>> children;
  final bool normalize;

  ContainerDistributionWidget(this.children, {Key key, this.normalize = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getRows);
  }

  int _flexOnRow(List<Expandable> liste) => liste.sumOf((e) => e.flex);

  int get _maxFlex => children.map((c) => _flexOnRow(c)).max();

  Row _getRow(List<Expandable> expandable) {
    var expanded = List<Widget>();
    for (var e in expandable) expanded.add(Expanded(child: e.child, flex: e.flex));
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
    );
  }

  List<Row> get _getRows => children.where((e) => e.length > 0).map((e) => _getRow(e)).toList();
}

class PlaygroundDistributionWidget extends StatefulWidget {
  final int fixed;
  final int maxFlex;
  final bool normalize;
  final List<Expandable> children;
  final DistributionType distribution;

  PlaygroundDistributionWidget(this.children,
      {Key key,
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
  List<Expandable> children;
  DistributionType distribution;

  _PlaygroundDistributionWidgetState(
      this.fixed, this.maxFlex, this.normalize, this.children, this.distribution);

  TextEditingController _fixedController;
  TextEditingController _maxFlexController;

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
          children,
          fixed: fixed,
          maxFlex: maxFlex,
          distribution: distribution,
          normalize: normalize,
        )
      ],
    );
  }
}
