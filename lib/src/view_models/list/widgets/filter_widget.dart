import 'package:flutter/material.dart';
import 'package:naples/src/view_models/list/filtered_view_model.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  FilterWidget({Key key}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState<T> extends State<FilterWidget> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_callFilter);
  }

  void _callFilter() {
    context.read<FilteredViewModel>().filterValue = _searchController.text;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Estaria bé que al fer escape marxés el Filtre

    return context.select<FilteredViewModel, bool>((vm) => vm.filtered)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Filter by',
                    ),
                    controller: _searchController,
                  )),
            ),
          )
        : Container();
  }
}
