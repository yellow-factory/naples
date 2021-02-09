//We need a collection editor

import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/edit.dart';
import 'package:naples/list.dart';
import 'package:navy/navy.dart';

//Combination of ExpandableList + Edit to edit a collection of items...
//Where T is type parent holding the collection
//Where Update is the type needed to update
//Where Create is the type needed to create
class CollectionEditor<T, Update, Create> extends StatefulWidget with Expandable {
  final int flex;
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Update> getUpdate;
  final FunctionOf1<Update, Iterable<Widget>> getUpdateLayoutMembers;
  final FunctionOf1<T, Create> getCreate;
  final FunctionOf1<Create, Iterable<Widget>> getCreateLayoutMembers;

  CollectionEditor({
    @required this.getStream,
    @required this.title,
    @required this.itemTitle,
    this.itemSubtitle,
    @required this.getUpdate,
    @required this.getUpdateLayoutMembers,
    this.getCreate,
    this.getCreateLayoutMembers,
    this.flex = 1,
    Key key,
  }) : super(key: key);

  @override
  _CollectionEditorState<T, Update, Create> createState() =>
      _CollectionEditorState<T, Update, Create>();
}

class _CollectionEditorState<T, Update, Create> extends State<CollectionEditor<T, Update, Create>> {
  T _selectedItem;
  int _length = 0;

  @override
  Widget build(BuildContext context) {
//TODO: Enlloc de fer servir ExpandableList hauria de fer servir una solució custom...
//TODO: Enlloc de fer servir el EditView potser vull fer servir el DynamicForm i afegir els botons de validar /cancel·lar a la capçalera del expanded??
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ExpandableList<T>(
              title: widget.title,
              getStream: widget.getStream,
              itemTitle: widget.itemTitle,
              select: (T itemToSelect) async {
                setState(() {
                  _selectedItem = itemToSelect;
                });
              },
            ),
          ),
          if (_selectedItem != null)
            Expanded(
              child: Card(
                child: EditView<Update>(
                  saveText: "Update property",
                  cancelText: "Cancel update property",
                  save: () {
                    setState(() {
                      _selectedItem = null;
                    });
                  },
                  cancel: () {
                    setState(() {
                      _selectedItem = null;
                    });
                  },
                  properties: widget.getUpdateLayoutMembers(widget.getUpdate(_selectedItem)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
