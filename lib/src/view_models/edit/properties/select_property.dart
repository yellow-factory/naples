import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/widgets/dropdown_widget.dart';
import 'package:naples/src/view_models/edit/properties/widgets/radio_list_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { DropDown, Radio }

///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectProperty<U, V> extends ModelProperty<U> {
  SelectWidgetType widgetType = SelectWidgetType.DropDown;
  final FunctionOf0<List<V>> listItems;
  final FunctionOf1<V, U> valueMember; //Function to project U from V
  final FunctionOf1<V, FunctionOf0<String>>
      displayMember; //Function to display the member as String

  SelectProperty(
    FunctionOf0<U> getProperty,
    this.listItems,
    this.valueMember,
    this.displayMember, {
    FunctionOf1<BuildContext, String> label,
    FunctionOf1<BuildContext, String> hint,
    int flex,
    bool autofocus = false,
    ActionOf1<U> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf2<BuildContext, U, String> isValid,
    this.widgetType,
  }) : super(
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  void initialize() {
    currentValue = getProperty();
  }

  @override
  Widget get widget {
    switch (widgetType) {
      case SelectWidgetType.DropDown:
        return ChangeNotifierProvider<SelectProperty<U, V>>.value(
            value: this, child: DropDownViewModelPropertyWidget<U, V>());
      case SelectWidgetType.Radio:
        return ChangeNotifierProvider<SelectProperty<U, V>>.value(
            value: this, child: RadioListViewModelPropertyWidget<U, V>());
      default:
        return ChangeNotifierProvider<SelectProperty<U, V>>.value(
            value: this, child: DropDownViewModelPropertyWidget<U, V>());
    }
  }
}
