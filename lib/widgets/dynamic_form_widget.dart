import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:provider/provider.dart';

class DynamicFormWidget extends StatelessWidget {
  final int columns;
  DynamicFormWidget({Key key, this.columns = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var properties =
    //     context.select<GetSetViewModel, Iterable<EditableViewModelProperty>>((x) => x.properties);

    final getSetViewModel = context.watch<GetSetViewModel>();
    final widgets = getSetViewModel.properties.map((e) => _getExpanded(e.widget, e.flex)).toList();
    final widgetRows = List<Widget>(); //List of all rows
    int flexOnRow = 0; //Sum flex of widgets on the current row
    var widgetsOnRow = List<Widget>(); //Widgets on the current row
    for (var widget in widgets) {
      widgetsOnRow.add(widget);
      flexOnRow += widget.flex;
      if (flexOnRow >= columns) {
        widgetRows.add(_getRow(widgetsOnRow));
        flexOnRow = 0;
        widgetsOnRow = List<Widget>();
      }
    }

    //The last row has not been created
    //First adds placeholders for the empty spaces
    while (flexOnRow < columns) {
      widgetsOnRow.add(_getExpanded(Container(), 1));
      flexOnRow++;
    }
    widgetRows.add(_getRow(widgetsOnRow)); //adds the last row

    //Return a Form with all the widgets
    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgetRows),
      autovalidate: true,
    );
  }

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
