import 'package:flutter/material.dart';
import 'package:naples/src/list/dynamic_list.dart';
import 'package:naples/src/list/list_loader.dart';
import 'package:naples/widgets/async_action_icon_button.dart';
import 'package:navy/navy.dart';

class FilteredViewModel<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;
  final FunctionOf1<T, Future<void>> select;
  final FunctionOf0<Future<void>> create;

  FilteredViewModel({
    @required this.getStream,
    @required this.itemTitle,
    this.title,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.select,
    this.create,
    Key key,
  }) : super(key: key);

  @override
  _FilteredViewModelState<T> createState() => _FilteredViewModelState<T>();
}

class _FilteredViewModelState<T> extends State<FilteredViewModel<T>> {
  final _listLoaderKey = GlobalKey<ListLoaderState<T>>();
  bool _filtered = false;
  String _filterValue = "";

  Future<void> _togleFiltered() async {
    setState(() {
      _filtered = !_filtered;
    });
  }

  bool Function(T) get _filterPredicate {
    var filterBy = _filterValue.toLowerCase().trim();
    if ((!_filtered) || filterBy.isEmpty) return (x) => true;
    return (x) => widget.itemTitle(x).toLowerCase().startsWith(filterBy);
  }

  List<T> _filteredItems(List<T> items) => items.where(_filterPredicate).toList();

  @override
  Widget build(BuildContext context) {
    return ListLoader<T>(
      key: _listLoaderKey,
      getStream: widget.getStream,
      builder: (items, loading) {
        return Scaffold(
          appBar: AppBar(
            title: widget.title == null ? null : Text(widget.title(items.length)),
            actions: <Widget>[
              AsyncActionIconButtonWidget(
                Icons.filter_list,
                _togleFiltered,
              ),
              AsyncActionIconButtonWidget(
                Icons.refresh,
                () async {
                  await _listLoaderKey.currentState.refresh();
                },
                message: "Refreshed!!",
              ),
            ],
          ),
          body: Column(
            children: <Widget>[
              if (loading) Container(child: LinearProgressIndicator()),
              if (_filtered)
                Card(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Filter by',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filterValue = value;
                      });
                    },
                  ),
                ),
              Expanded(
                child: DynamicList<T>(
                  items: _filtered ? _filteredItems(items) : items,
                  itemTitle: widget.itemTitle,
                  itemSubtitle: widget.itemSubtitle,
                  itemLeading: widget.itemLeading,
                  itemTrailing: widget.itemTrailing,
                  select: widget.select,
                ),
              ),
            ],
          ),
          floatingActionButton: widget.create == null
              ? null
              : FloatingActionButton(
                  onPressed: () async {
                    await widget.create();
                  },
                  tooltip: 'New model', //TODO: Això s'hauria de parametritzar, i l'icona també?
                  child: Icon(Icons.add),
                ),
        );
      },
    );
  }
}