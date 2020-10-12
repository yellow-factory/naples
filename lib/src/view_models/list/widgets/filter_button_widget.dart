import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:provider/provider.dart';

//Posa la llista en mode filtre per tal que mostri el widget per introduir la cerca
class FilterButtonWidget extends StatelessWidget {
//TODO: Potser hauria de ser més general, i hauria de servir per aquest cas però potser també per el TableViewModel, etc.
//si fos així voldria dir que enlloc de ser depenent de ListViewModel ho hauria de ser d'una interfície que aquest implementés,
//per tant caldria enregistrar dos cops el valor a través de dos proveïdors, etc. S'hauria de provar.

  FilterButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.filter_list),
      onPressed: () async {
        context.read<FilteredViewModel>().togleFiltered();
      },
    );
  }
}