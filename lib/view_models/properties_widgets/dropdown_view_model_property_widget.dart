import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/view_models/properties.dart';

class DropDownViewModelPropertyWidget<T, U, V> extends StatelessWidget {
  final SelectViewModelProperty<T, U, V> property;

  DropDownViewModelPropertyWidget(this.property);

//TODO: El DropdownSearch no s'adapta bé al que volem, n'hauríem de fer un propi

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<V>(
      validator: (_) => property.validate(),
      hint: property.hint(),
      mode: Mode.MENU,
      showSelectedItem: true,
      items: property.listItems(),
      label: property.label(),
      showClearButton: true,
      onChanged: print,
      //Per treure la decoració tipus outline...
      // dropdownSearchDecoration: InputDecoration(
      //     contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0), border: UnderlineInputBorder()),
      //popupItemDisabled: (String s) => s.startsWith('I'),
      //selectedItem: property.currentValue, --> Aquesta no s'adapta
    );
  }
}
