import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_naples/view_models/properties.dart';
import 'package:provider/provider.dart';

class TextViewModelPropertyWidget extends StatelessWidget {
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatters;

  TextViewModelPropertyWidget({this.textInputType, this.textInputFormatters});

  @override
  Widget build(BuildContext context) {
    final property = context.watch<TextViewModelProperty>();
    return TextFormField(
      initialValue: property.currentValue,
      decoration: InputDecoration(
        //filled: true,
        hintText: property.hint != null ? property.hint() : null,
        labelText: property.label(),
      ),
      enabled: property.editable,
      autofocus: property.autofocus,
      validator: (_) => property.validate(),
      keyboardType: textInputType,
      inputFormatters: textInputFormatters,
      onChanged: (value) {
        property.currentValue = value;
        property.update();
        //TODO: Quan es fa l'update es passa el valor al model, i no sé si en tots
        //els casos és el que volem, potser podríem tenir una opció (autoupdate)
        //si no ho fem, els visibles, editables, etc. no s'actualitzaran correctament,
        //però no sé quan és el millor moment, si quan es fa el canvi o quan es fa l'update explícit de la viewmodel
      },
    );
  }
}
