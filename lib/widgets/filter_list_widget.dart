import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/view_models/view_model.dart';

class FilterListWidget extends StatefulWidget {
  FilterListWidget({Key key}) : super(key: key);

  @override
  _FilterListWidgetState createState() => _FilterListWidgetState();
}

class _FilterListWidgetState extends State<FilterListWidget> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_callFilter);
  }

  void _callFilter() {
    context.read<ListViewModel>().filterValue = _searchController.text;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: Estaria bé que al fer escape marxés el Filtre

    return context.select<ListViewModel, bool>((vm) => vm.filtered)
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
