import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/view_models/properties.dart';

class DropDownViewModelPropertyWidget<T, U> extends StatelessWidget {
  final SelectViewModelProperty<T, U> property;

  DropDownViewModelPropertyWidget(this.property);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<U>(
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
      selectedItem: property.currentValue,
    );
  }
}
