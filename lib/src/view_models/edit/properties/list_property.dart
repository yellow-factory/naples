import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:naples/src/view_models/edit/properties/widgets/datetime_widget.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';

//TODO: També es podria plantejar que hi hagués una ViewProperty que fos un contenidor d'una altra ViewModel,
//i fer que allotgés directament una list_view_model (container_property)

class ListProperty<T> extends ViewProperty {
  final FunctionOf0<List<T>> getProperty;
  final FunctionOf0<String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;

  ListProperty(
    this.getProperty,
    this.itemTitle, {
    this.title,
    this.itemSubtitle,
    int flex = 1,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
  }) : super(
          flex: flex,
          isVisible: isVisible,
        ) {
    initialize();
  }

  @override
  Widget get widget => ChangeNotifierProvider<ListProperty>.value(
      value: this, child: DateTimeViewModelPropertyWidget());

  void initialize() {
    //currentValue = getProperty();
  }
}
