import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/list.dart';
import 'package:naples/load.dart';
import 'package:naples/widgets.dart';
import 'package:navy/navy.dart';

//Combination of List + Edit to edit a collection of items...
//Where T is type parent holding the collection
//Where Update is the type needed to update
//Where Create is the type needed to create
class CollectionEditor<ListItem, Update, Create> extends StatefulWidget with Expandable {
  final int flex;
  final List<ListItem> items;
  final FunctionOf1<ListItem, String> itemTitle;
  final FunctionOf1<ListItem, String> itemSubtitle;

  //TODO: Si volguessim tenir una vista diferent per al get i després passar al edit també es podria fer, i
  //es podria afegir alguna cosa com ...
  //final FunctionOf2<ListItem, FunctionOf1<Widget, Widget>, Widget> getWidget;

  //TODO: En alguns casos potser ens pot interessar que tingui títol i potser vora perquè estigui delimitat

  final FunctionOf1<ListItem, Future<Update>> getUpdate;
  final FunctionOf2<Update, FunctionOf2<Widget, bool, Widget>, Widget> updateWidget;
  final FunctionOf1<Update, Future<ListItem>> update;

  final FunctionOf0<Future<Create>> getCreate;
  final FunctionOf2<Create, FunctionOf2<Widget, bool, Widget>, Widget> createWidget;
  final FunctionOf1<Create, Future<ListItem>> create;

  final bool callRefreshAfterEdit;

  CollectionEditor({
    @required this.items,
    @required this.itemTitle,
    this.itemSubtitle,
    @required this.getUpdate,
    @required this.updateWidget,
    @required this.update,
    this.getCreate,
    this.createWidget,
    this.create,
    this.flex = 1,
    this.callRefreshAfterEdit = false,
    Key key,
  }) : super(key: key);

  @override
  _CollectionEditorState<ListItem, Update, Create> createState() =>
      _CollectionEditorState<ListItem, Update, Create>();

  bool get existCreate => getCreate != null && create != null && createWidget != null;
}

class _CollectionEditorState<ListItem, Update, Create>
    extends State<CollectionEditor<ListItem, Update, Create>> {
  ListItem _selectedItem;
  Update _updateItem;
  Create _createItem;
  List<ListItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List<ListItem>.from(widget.items);
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_items.length != widget.items.length) {
      _items = List<ListItem>.from(widget.items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              if (widget.existCreate) getCreateButton(context),
              Expanded(
                child: DynamicList(
                  items: _items,
                  itemTitle: widget.itemTitle,
                  itemSubtitle: widget.itemSubtitle,
                  separated: true,
                  select: (item) async {
                    var updateItem = await widget.getUpdate(item);
                    setState(() {
                      _createItem = null;
                      _selectedItem = item;
                      _updateItem = updateItem;
                    });
                    return;
                  },
                ),
              ),
            ],
          ),
        ),
        if (_updateItem != null) getUpdateWidget(context),
        if (_createItem != null) getCreateWidget(context),
      ],
    );
  }

  Widget getCreateButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: OutlinedButton.icon(
          onPressed: () async {
            var createItem = await widget.getCreate();
            setState(() {
              _updateItem = null;
              _createItem = createItem;
            });
          },
          icon: Icon(Icons.add),
          label: Text("NEW"),
          //style: OutlinedButton.styleFrom(side: ),
        ),
      ),
    );
  }

  Widget getUpdateWidget(BuildContext context) {
    return Expanded(
      child: Card(
        child: widget.updateWidget(
          _updateItem,
          (form, valid) {
            return getEditWidget(
              context,
              form,
              valid,
              () async {
                var updatedItem = await widget.update(_updateItem);
                var i = _items.indexOf(_selectedItem);
                setState(() {
                  _items.removeAt(i);
                  _items.insert(i, updatedItem);
                });
              },
              () {
                setState(() {
                  _updateItem = null;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget getCreateWidget(BuildContext context) {
    return Expanded(
      child: Card(
        child: widget.createWidget(
          _createItem,
          (form, valid) {
            return getEditWidget(
              context,
              form,
              valid,
              () async {
                var newItem = await widget.create(_createItem);
                setState(() {
                  _items.insert(0, newItem);
                });
              },
              () {
                setState(() {
                  _createItem = null;
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget getEditWidget(
    BuildContext context,
    Widget form,
    bool valid,
    Function save,
    Function cancel,
  ) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          form,
          ActionsListWidget(
            actions: <ActionWidget>[
              ActionWidget(
                title: "save",
                action: !valid
                    ? null
                    : () {
                        save();
                        if (widget.callRefreshAfterEdit)
                          NeedsRefreshNotification().dispatch(context);
                        cancel();
                      },
                primary: true,
              ),
              ActionWidget(
                title: "cancel",
                action: cancel,
              ),
            ],
          ),
        ],
      ),
    );
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

}
