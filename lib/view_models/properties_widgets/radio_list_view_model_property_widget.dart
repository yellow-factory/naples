import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/view_models/properties.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/view_models/view_model.dart';

class RadioListViewModelPropertyWidget<T, U, V> extends StatelessWidget {
  //final SelectViewModelProperty<T, U, V> property;

  RadioListViewModelPropertyWidget();

  //TODO: isValid is not being validated

  @override
  Widget build(BuildContext context) {
    final property = context.watch<SelectViewModelProperty<T, U, V>>();
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(children: <Widget>[
        ListTile(title: Text(property.label()), subtitle: Text(property.hint())),
        for (var item in property.listItems())
          RadioListTile<U>(
            title: Text(property.displayMember(item)()),
            value: property.valueMember(item),
            groupValue: property.currentValue,
            onChanged: property.editable
                ? (U value) {
                    setState(() {
                      property.currentValue = value;
                      property
                          .update(); //Notifica canvis per tal que s'actualitzi el camp, però en realitat el que volem és que es notifiquin els canvis al viewmodel
                      var vm =
                          context.read<ViewModel>(); //Segurament això s'hauria de fer al update...
                      vm.notifyListeners();
                      //Segurament provocant el canvi de ViewModel es pot obviar el canvi de la propietat, que es refarà sola al actualitzar el ViewModel,
                      //però d'altra banda potser estaria més ben fet així...
                      //TODO: Ara també caldria fer que fos amb el isvisible a més del iseditable
                    });
                  }
                : null,
          )
      ]);
    });
  }
}
