import 'package:flutter/material.dart';
import 'package:yellow_naples/utils.dart';
import 'package:list_ext/list_ext.dart';

enum DynamicFormDistribution { LeftToRight, TopToBottom }

class DynamicFormWidget extends StatelessWidget {
  //Refers to columns when fixing columns (left to right distribution)
  //and refers to rows when fixing rows (top to bottom distribution)
  final int fixed;
  final bool normalize;
  final List<Expandable> children;
  final DynamicFormDistribution distribution;

  DynamicFormWidget(this.children,
      {Key key,
      this.fixed = 1,
      this.normalize = true,
      this.distribution = DynamicFormDistribution.LeftToRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return distribution == DynamicFormDistribution.LeftToRight
        ? LeftToRightDynamicFormWidget(children, columns: fixed, normalize: normalize)
        : TopToBottomDynamicFormWidget(children, rows: fixed, normalize: normalize);
  }
}

class TopToBottomDynamicFormWidget extends StatelessWidget {
  final int rows;
  final List<Expandable> children;
  final bool normalize;

  TopToBottomDynamicFormWidget(this.children, {Key key, this.rows = 1, this.normalize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //In this case the number of rows is fixed...
    //List of all rows
    final widgetRows = List<List<Expandable>>.generate(rows, (int index) => List<Expandable>());
    var currentRow = PrimitiveWrapper<int>(0);
    var currentColumn = PrimitiveWrapper<int>(0);
    for (var w in children) {
      var row = _getNextRow(widgetRows, currentRow, currentColumn);
      row.add(w);
    }
    return ContainerDynamicFormWidget(widgetRows, normalize: normalize);
  }

  List<Expandable> _getNextRow(List<List<Expandable>> widgetRows, PrimitiveWrapper<int> currentRow,
      PrimitiveWrapper<int> currentColumn) {
    if (currentRow.value >= rows) {
      //If necessary returns to the first row and changes column
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

  int _flexOnRow(List<Expandable> widgets) =>
      widgets.length == 0 ? 0 : widgets.sumOf((element) => element.flex);
}

class LeftToRightDynamicFormWidget extends StatelessWidget {
  final int columns;
  final List<Expandable> children;
  final bool normalize;

  LeftToRightDynamicFormWidget(this.children, {Key key, this.columns = 1, this.normalize = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //The number of columns is fixed...
    final widgetRows = <List<Expandable>>[
      List<Expandable>()
    ]; //List of all rows, initialize first row
    int currentRow = 0;
    int flexOnRow = 0; //Sum flex of widgets on the current row
    for (var w in children) {
      //It has to create an Expanded
      w.flex = [w.flex, columns].min();
      var row = widgetRows[currentRow];
      if (flexOnRow + w.flex < columns) {
        //Adds the widget to the current row of widgets
        row.add(w);
        flexOnRow += w.flex;
        continue;
      }
      if (flexOnRow + w.flex == columns) {
        row.add(w);
        //Initialize row values
        flexOnRow = 0;
        currentRow++;
        widgetRows.add(List<Expandable>());
        continue;
      }
      //If the new widget has a flex that overflows current row
      if (flexOnRow + w.flex > columns) {
        currentRow++;
        widgetRows.add(List<Expandable>());
        widgetRows[currentRow].add(w);
        flexOnRow = w.flex;
      }
    }
    return ContainerDynamicFormWidget(widgetRows, normalize: normalize);
  }
}

class ContainerDynamicFormWidget extends StatelessWidget {
  final List<List<Expandable>> children;
  final bool normalize;

  ContainerDynamicFormWidget(this.children, {Key key, this.normalize = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Return a Form with all the widgets
    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: _getRows),
      autovalidate: true,
    );
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

class DynamicFormPlaygroundWidget extends StatefulWidget {
  final int fixed;
  final bool normalize;
  final List<Expandable> children;
  final DynamicFormDistribution distribution;

  DynamicFormPlaygroundWidget(this.children,
      {Key key,
      this.fixed = 1,
      this.normalize = true,
      this.distribution = DynamicFormDistribution.LeftToRight})
      : super(key: key);

  @override
  _DynamicFormPlaygroundWidgetState createState() =>
      _DynamicFormPlaygroundWidgetState(fixed, normalize, children, distribution);
}

class _DynamicFormPlaygroundWidgetState extends State<DynamicFormPlaygroundWidget> {
  int fixed;
  bool normalize;
  List<Expandable> children;
  DynamicFormDistribution distribution;
  _DynamicFormPlaygroundWidgetState(this.fixed, this.normalize, this.children, this.distribution);

  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController(text: fixed.toString());
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            //margin: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
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
            value: distribution != DynamicFormDistribution.LeftToRight,
            onChanged: (value) => setState(() => value
                ? distribution = DynamicFormDistribution.TopToBottom
                : distribution = DynamicFormDistribution.LeftToRight),
          ),
          new ListTile(
              title: Text("Fixed rows/columns"),
              subtitle: Text("TODO: Hint of Fixed..."),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              trailing: new Container(
                  width: 50,
                  height: 50,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        print(value);
                        if (value != null && value.isNotEmpty) fixed = int.parse(value);
                      });
                    },
                  )))
        ])),
        DynamicFormWidget(
          children,
          fixed: fixed,
          distribution: distribution,
          normalize: normalize,
        )
      ],
    );
  }
}

class Expandable {
  final Widget child;
  int flex;
  Expandable(this.child, this.flex);
}
