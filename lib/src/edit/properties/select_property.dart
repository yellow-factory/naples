import 'dart:async'; // Added for FutureOr

import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/radio_list_form_field.dart';
import 'package:naples/src/widgets/select_dialog_form_field.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/property.dart';

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { dropDown, radio, dialog }

///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectProperty<U, V> extends PropertyWidget<U?> with PropertyMixin<U?> implements Expandable {
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
  final FunctionOf0<FutureOr<List<V>>> listItems; // Changed type here
  //Function to project U from V
  final FunctionOf1<V, U> valueMember;
  //Function to display the member as String
  final FunctionOf1<V, FunctionOf0<String>> displayMember;
  //Calls setProperty on control value change
  final bool saveOnValueChanged;

  SelectProperty({
    super.key,
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
    this.widgetType = SelectWidgetType.dropDown,
    this.saveOnValueChanged = false,
  });

  @override
  Widget build(BuildContext context) {
    if (widgetType == SelectWidgetType.dialog) {
      // For dialogs, pass listItems directly to _getDialog,
      // which will pass it to SelectDialogFormField for deferred loading.
      return _getDialog();
    }

    // For dropdown and radio, resolve listItems upfront.
    final itemsFutureOrList = listItems();

    if (itemsFutureOrList is Future<List<V>>) {
      return FutureBuilder<List<V>>(
        future: itemsFutureOrList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error loading items: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            return _buildNonDialogWidgets(snapshot.data!);
          }
          return const Text("No items to select"); // Should not happen if future resolves
        },
      );
    } else {
      // Synchronous case
      return _buildNonDialogWidgets(itemsFutureOrList);
    }
  }

  Widget _buildNonDialogWidgets(List<V> resolvedItems) {
    // This helper handles widgets that require items to be pre-loaded.
    switch (widgetType) {
      case SelectWidgetType.dropDown:
        return _getDropDown(resolvedItems);
      case SelectWidgetType.radio:
        return _getRadioList(resolvedItems);
      case SelectWidgetType.dialog:
        // This case should not be reached here as dialogs are handled separately.
        return const SizedBox.shrink(); // Should ideally throw an error or be unreachable
    }
  }

  Widget _getRadioList(List<V> items) {
    final radioKey = GlobalKey<FormFieldState<U>>();
    return RadioListFormField<U, V>(
      key: radioKey,
      label: label,
      hint: hint,
      autofocus: autofocus,
      displayMember: displayMember,
      valueMember: valueMember,
      listItems: () => items, // Changed: pass resolved items
      enabled: enabled,
      initialValue: getProperty(),
      onSaved: setProperty,
      validator: validator,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) {
        if (radioKey.currentState == null) return;
        if (saveOnValueChanged) radioKey.currentState!.save();
        // I THINK THIS IS NOT NEEDED
        // if (radioKey.currentState!.value != value) {
        //   radioKey.currentState!.didChange(value);
        // }
      },
    );
  }

  Widget _getDialog() {
    // No 'items' parameter needed here, as listItems is passed directly.
    final dialogKey = GlobalKey<FormFieldState<U>>();
    return SelectDialogFormField<U, V>(
      key: dialogKey,
      label: label,
      hint: hint,
      // autofocus is not directly applicable to SelectDialogFormField's TextField in this setup
      // as it's read-only. Autofocus for the dialog itself would be handled by showSelectDialog.
      enabled: enabled,
      initialValue: getProperty(),
      onSaved: setProperty,
      validator: validator,
      listItems: listItems, // Pass the original listItems function
      valueMember: valueMember,
      displayMember: displayMember,
      onChanged: (value) {
        if (dialogKey.currentState == null) return;
        if (saveOnValueChanged) dialogKey.currentState!.save();
      },
    );
  }

  Widget _getDropDown(List<V> itemsProvided) {
    final dropdownKey = GlobalKey<FormFieldState<U>>();
    if (itemsProvided.isEmpty) {
      return const Text("No items to select", overflow: TextOverflow.ellipsis);
    }
    final items = <DropdownMenuItem<U>>[
      for (var item in itemsProvided)
        DropdownMenuItem<U>(
          value: valueMember(item),
          child: Text(displayMember(item)(), overflow: TextOverflow.ellipsis),
        ),
    ];
    return DropdownButtonFormField<U>(
      key: dropdownKey,
      items: items,
      value: getProperty(),
      onSaved: setProperty,
      validator: validator,
      autofocus: autofocus,
      decoration: InputDecoration(labelText: label, hintText: hint),
      onChanged: (value) {
        if (dropdownKey.currentState == null) return;
        if (saveOnValueChanged) dropdownKey.currentState!.save();
        // I THINK THIS IS NOT NEEDED
        // if (dropdownKey.currentState!.value != value) {
        //   dropdownKey.currentState!.didChange(value);
        // }
      },
    );
  }
}
