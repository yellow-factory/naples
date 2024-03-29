import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/radio_list_form_field.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { DropDown, Radio }

///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectProperty<U, V> extends ModelPropertyWidget<U?>
    with ModelPropertyMixin<U?>
    implements Expandable {
  @override
  final int flex;
  @override
  final String label;
  @override
  final String? hint;
  @override
  final bool autofocus;
  @override
  final PredicateOf0? editable;
  @override
  final FunctionOf0<U?> getProperty;
  @override
  final ActionOf1<U?>? setProperty;
  @override
  final FunctionOf1<U?, String?>? validator;
  final SelectWidgetType widgetType;
  final FunctionOf0<List<V>> listItems;
  //Function to project U from V
  final FunctionOf1<V, U> valueMember;
  //Function to display the member as String
  final FunctionOf1<V, FunctionOf0<String>> displayMember;
  //Calls setProperty on control value change
  final bool saveOnValueChanged;

  SelectProperty({
    Key? key,
    required this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    required this.listItems,
    required this.valueMember,
    required this.displayMember,
    this.widgetType = SelectWidgetType.DropDown,
    this.saveOnValueChanged = false,
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
        if (dropdownKey.currentState == null) return;
        if (saveOnValueChanged) dropdownKey.currentState!.save();
        if (dropdownKey.currentState!.value != value) {
          dropdownKey.currentState!.didChange(value);
        }

        //print('didchange selectpropery');
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
          enabled: enabled,
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
