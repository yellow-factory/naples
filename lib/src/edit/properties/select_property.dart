import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/widgets/radio_list_form_field.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { DropDown, Radio }

///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectProperty<U, V> extends StatelessWidget with ModelProperty<U>, Expandable {
  final int flex;
  final String label;
  final String hint;
  final bool autofocus;
  final PredicateOf0 editable;
  final FunctionOf0<U> getProperty;
  final ActionOf1<U> setProperty;
  final FunctionOf1<U, String> validator;
  final SelectWidgetType widgetType;
  final FunctionOf0<List<V>> listItems;
  //Function to project U from V
  final FunctionOf1<V, U> valueMember;
  //Function to display the member as String
  final FunctionOf1<V, FunctionOf0<String>> displayMember;

  SelectProperty({
    Key key,
    this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    @required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    @required this.listItems,
    @required this.valueMember,
    @required this.displayMember,
    this.widgetType = SelectWidgetType.DropDown,
  }) : super(key: key);

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
      validator: validator,
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
        return RadioListFormField<U, V>(
          label: label,
          hint: hint,
          autofocus: autofocus,
          displayMember: displayMember,
          valueMember: valueMember,
          listItems: listItems,
          enabled: editable == null ? true : editable(),
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: validator,
          controlAffinity: ListTileControlAffinity.leading,
        );
      default:
        return defaultWidget;
    }
  }
}
