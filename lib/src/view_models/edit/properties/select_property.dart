import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/widgets/radio_list_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { DropDown, Radio }

///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectProperty<U, V> extends ModelProperty<U> {
  final SelectWidgetType widgetType;
  final FunctionOf0<List<V>> listItems;
  //Function to project U from V
  final FunctionOf1<V, U> valueMember;
  //Function to display the member as String
  final FunctionOf1<V, FunctionOf0<String>> displayMember;

  SelectProperty({
    FunctionOf0<U> getProperty,
    this.listItems,
    this.valueMember,
    this.displayMember,
    String label,
    String hint,
    int flex,
    bool autofocus = false,
    ActionOf1<U> setProperty,
    PredicateOf0 isEditable,
    FunctionOf1<U, String> isValid,
    this.widgetType = SelectWidgetType.DropDown,
  }) : super(
          getProperty: getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  Widget build(BuildContext context) {
    final items = <DropdownMenuItem<U>>[
      for (var item in listItems())
        DropdownMenuItem<U>(
          value: valueMember(item),
          child: Text(displayMember(item)()),
        )
    ];
    final dropdownKey = GlobalKey<FormFieldState<U>>();
    final defaultWidget = DropdownButtonFormField<U>(
      key: dropdownKey,
      items: items,
      value: getProperty(),
      onSaved: setProperty,
      validator: isValid,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      onChanged: (value) {
        dropdownKey.currentState.didChange(value);
      },
    );

    switch (widgetType) {
      case SelectWidgetType.DropDown:
        return defaultWidget;
      case SelectWidgetType.Radio:
        return RadioListViewModelPropertyWidget<U, V>(
          label: label,
          hint: hint,
          autofocus: autofocus,
          displayMember: displayMember,
          valueMember: valueMember,
          listItems: listItems,
          enabled: isEditable == null ? true : isEditable(),
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: isValid,
          controlAffinity: ListTileControlAffinity.leading,
        );
      default:
        return defaultWidget;
    }
  }
}
