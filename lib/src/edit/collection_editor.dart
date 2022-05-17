import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/edit.dart';
import 'package:naples/list.dart';
import 'package:naples/widgets.dart';
import 'package:navy/navy.dart';

//Combination of List + Edit to edit a collection of items...
//Where ListItem is the type holding the collection
//Where Update is the type needed to update
//Where Create is the type needed to create
class CollectionEditor<ListItem, Update, Create> extends StatefulWidget with Expandable {
  @override
  final int flex;
  final List<ListItem> items;
  final FunctionOf1<ListItem, String> itemTitle;
  final FunctionOf1<ListItem, String>? itemSubtitle;

  //TODO: Si volguessim tenir una vista diferent per al get i després passar al edit també es podria fer, i
  //es podria afegir alguna cosa com ...
  //final FunctionOf2<ListItem, FunctionOf1<Widget, Widget>, Widget> getWidget;

  final FunctionOf1<ListItem, Future<Update>> getUpdate;
  final FunctionOf2<ListItem, Update, Widget> updateWidget;
  final FunctionOf2<ListItem, Update, Future<ListItem>> update;

  final FunctionOf0<Future<Create>>? getCreate;
  final FunctionOf1<Create, Widget>? createWidget;
  final FunctionOf1<Create, Future<ListItem>>? create;

  final FunctionOf1<ListItem, Future<bool>>? delete;

  CollectionEditor({
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    required this.getUpdate,
    required this.updateWidget,
    required this.update,
    this.getCreate,
    this.createWidget,
    this.create,
    this.delete,
    this.flex = 1,
    Key? key,
  }) : super(key: key);

  @override
  CollectionEditorState<ListItem, Update, Create> createState() =>
      CollectionEditorState<ListItem, Update, Create>();

  bool get existCreate => getCreate != null && create != null && createWidget != null;
}

enum CollectionEditorMode { list, create, update }

class CollectionEditorState<ListItem, Update, Create>
    extends State<CollectionEditor<ListItem, Update, Create>> {
  ListItem? _selectedItem;
  Update? _updateItem;
  Create? _createItem;
  late List<ListItem> _items;
  var _mode = CollectionEditorMode.list;

  @override
  void initState() {
    super.initState();
    _items = List<ListItem>.from(widget.items);
  }

  @override
  void didUpdateWidget(CollectionEditor<ListItem, Update, Create> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_items.length != widget.items.length) {
      _items = List<ListItem>.from(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.existCreate) getCreateButton(context),
        const Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: DynamicList(
                        items: _items,
                        itemTitle: widget.itemTitle,
                        itemSubtitle: widget.itemSubtitle,
                        separated: true,
                        select: (ListItem item) async {
                          var updateItem = await widget.getUpdate(item);
                          setState(() {
                            _mode = CollectionEditorMode.update;
                            _createItem = null;
                            _selectedItem = item;
                            _updateItem = updateItem;
                          });
                        },
                        itemTrailing: widget.delete == null
                            ? (ListItem item) => IconButton(
                                  onPressed: () => delete(item),
                                  icon: const Icon(Icons.delete),
                                )
                            : null,
                        onlyShowItemTrailingOnHover: true,
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              if (_mode == CollectionEditorMode.update) getUpdateWidget(context),
              if (_mode == CollectionEditorMode.create) getCreateWidget(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget getCreateButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: OutlinedButton.icon(
          onPressed: () async {
            if (widget.getCreate == null) return;
            var createItem = await widget.getCreate!();
            setState(() {
              _mode = CollectionEditorMode.create;
              _updateItem = null;
              _createItem = createItem;
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("NEW"),
          //style: OutlinedButton.styleFrom(side: ),
        ),
      ),
    );
  }

  Widget getUpdateWidget(BuildContext context) {
    if (_selectedItem == null) return const Placeholder();
    if (_updateItem == null) return const Placeholder();
    var updateWidget = widget.updateWidget(
      _selectedItem as ListItem,
      _updateItem as Update,
    );
    return _InnerEditWidget(
      title: "UPDATE",
      form: updateWidget,
      accept: update,
      cancel: cancelUpdate,
    );
  }

  Future<void> update() async {
    if (_selectedItem == null) return;
    var updatedItem = await widget.update(_selectedItem as ListItem, _updateItem as Update);
    var i = _items.indexOf(_selectedItem as ListItem);
    setState(() {
      _items.removeAt(i);
      _items.insert(i, updatedItem);
    });
  }

  void cancelUpdate() {
    setState(() {
      _updateItem = null;
      _mode = CollectionEditorMode.list;
    });
  }

  Widget getCreateWidget(BuildContext context) {
    if (_createItem == null) return const Placeholder();
    if (widget.createWidget == null) return const Placeholder();
    return _InnerEditWidget(
      title: "CREATE",
      form: widget.createWidget!(_createItem as Create),
      accept: create,
      cancel: cancelCreate,
    );
  }

  Future<void> create() async {
    var newItem = await widget.create!(_createItem as Create);
    setState(() {
      _items.insert(0, newItem);
    });
  }

  void cancelCreate() {
    setState(() {
      _createItem = null;
      _mode = CollectionEditorMode.list;
    });
  }

  Future<void> delete(ListItem listItem) async {
    if (widget.delete == null) return;
    var deleted = await widget.delete!(listItem);
    if (deleted) {
      setState(() {
        _items.remove(listItem);
      });
    }
    if (listItem == _selectedItem) {
      setState(() {
        _selectedItem = null;
        _updateItem = null;
      });
    }
  }
}

class _InnerEditWidget extends StatelessWidget {
  final Widget form;
  final Function accept;
  final Function cancel;
  final String? title;

  const _InnerEditWidget({
    Key? key,
    required this.form,
    required this.accept,
    required this.cancel,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValidForm(
      validateOnFormChanged: true,
      child: form,
      builder: (validformstate) {
        return Expanded(
          child: Column(
            children: <Widget>[
              if (title != null)
                Column(
                  children: [
                    ListTile(
                      title: Text(title!),
                      tileColor: Colors.grey.shade200,
                    ),
                    const Divider(height: 1),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    validformstate.form,
                    ActionsListWidget(
                      actions: <ActionWidget>[
                        ActionWidget(
                          title: "accept",
                          action: !validformstate.valid
                              ? null
                              : () {
                                  if (!validformstate.validate()) return;
                                  accept();
                                  cancel();
                                },
                          primary: true,
                        ),
                        ActionWidget(
                          title: "cancel",
                          action: () => cancel(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//TODO: Probablement hauria de tenir dos vistes, una per pantalles grans i una altra per petites(mòbil)
//A les pantalles petites, el botó de crear hauria de ser amb un floating action button, però
//a les grans no, per a les petites:
// Stack(
//   children: [
//     DynamicList(),
//     Positioned(
//       bottom: 20,
//       right: 20,
//       child: FloatingActionButton(
//         onPressed: () {
//           print('hola');
//         },
//         child: Icon(Icons.add),
//       ),
//     ),
//   ],
// ),
