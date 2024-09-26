import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/dialogs.dart';
import 'package:naples/list.dart';
import 'package:naples/widgets.dart';
import 'package:navy/navy.dart';

//Combination of List + Edit to edit a collection of items...(add,delete,update)
//Where ListItem is the type holding the collection
class CollectionEditor<ListItem> extends StatefulWidget implements Expandable {
  final FunctionOf0<String>? title;
  @override
  final int flex;
  final List<ListItem> items;
  final FunctionOf1<ListItem, String> itemTitle;
  final FunctionOf1<ListItem, String>? itemSubtitle;

  final FunctionOf1<ListItem, Widget> updateWidget;
  final ActionOf0 update;

  final FunctionOf0<Widget>? createWidget;
  final ActionOf0? create;

  final ActionOf1<ListItem>? delete;

  final PredicateOf0? editable;

  const CollectionEditor({
    this.title,
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    required this.updateWidget,
    required this.update,
    this.createWidget,
    this.create,
    this.delete,
    this.flex = 1,
    this.editable,
    Key? key,
  }) : super(key: key);

  @override
  CollectionEditorState<ListItem> createState() => CollectionEditorState<ListItem>();

  bool get existCreate =>
      create != null && createWidget != null && (editable == null || editable!());
}

enum CollectionEditorMode { list, create, update }

class CollectionEditorState<ListItem> extends State<CollectionEditor<ListItem>> {
  ListItem? _selectedItem;
  var _mode = CollectionEditorMode.list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    widget.title == null ? '' : widget.title!(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )),
            ),
            if (widget.existCreate) getCreateButton(context),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: DynamicList(
                        items: widget.items,
                        itemTitle: widget.itemTitle,
                        itemSubtitle: widget.itemSubtitle,
                        separated: true,
                        select: (ListItem item) async {
                          if (widget.editable == null || !widget.editable!()) return;
                          setState(() {
                            _mode = CollectionEditorMode.update;
                            _selectedItem = item;
                          });
                        },
                        itemTrailing:
                            widget.delete != null && (widget.editable == null || widget.editable!())
                                ? (ListItem item) => IconButton(
                                      onPressed: () async => await delete(item),
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
            setState(() {
              _mode = CollectionEditorMode.create;
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("NEW"),
          //style: OutlinedButton.styleFrom(side: ),
        ),
      ),
    );
  }

  Widget getCreateWidget(BuildContext context) {
    var widgetCreator = widget.createWidget;
    if (widgetCreator == null) return const Placeholder();
    return _InnerEditWidget(
      title: "CREATE",
      accept: create,
      cancel: cancel,
      child: widgetCreator(),
    );
  }

  Widget getUpdateWidget(BuildContext context) {
    if (_selectedItem == null) return const Placeholder();
    var updateWidget = widget.updateWidget(_selectedItem as ListItem);
    return _InnerEditWidget(
      key: UniqueKey(),
      title: "UPDATE",
      accept: update,
      cancel: cancel,
      child: updateWidget,
    );
  }

  void update() {
    if (_selectedItem == null) return;
    widget.update();
  }

  void cancel() {
    setState(() {
      _mode = CollectionEditorMode.list;
      _selectedItem = null;
    });
  }

  void create() {
    if (widget.create == null) return;
    widget.create!();
  }

  Future<void> delete(ListItem listItem) async {
    if (widget.delete == null) return;
    var result = await showConfirmDeleteDialog(
        context: context, itemName: 'item ${widget.itemTitle(listItem)}');
    if (result == YesNoDialogOptions.no) return;
    widget.delete!(listItem);
    if (listItem == _selectedItem) {
      cancel();
    } else {
      setState(() {}); //To refresh the list of items
    }
  }
}

class _InnerEditWidget extends StatelessWidget {
  final Widget child;
  final Function accept;
  final Function cancel;
  final String? title;

  const _InnerEditWidget({
    Key? key,
    required this.child,
    required this.accept,
    required this.cancel,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child,
                ActionsListWidget(
                  actions: <ActionWidget>[
                    ActionWidget(
                      title: "accept",
                      action: () {
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
