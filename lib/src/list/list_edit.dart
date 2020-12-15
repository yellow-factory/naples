import 'package:flutter/material.dart';
import 'package:naples/list.dart';
import 'package:naples/src/list/list_loader.dart';
import 'package:navy/navy.dart';

///Receives a list and edits it's data on the side through an edit component
///It provides a way to add new elements to the list
class ListSideEdit<T> extends StatelessWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;

  ListSideEdit({
    @required this.getStream,
    @required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.title,
    Key key,
  }) : super(key: key);

  final _listLoaderKey = GlobalKey<ListLoaderState<T>>();

//TODO: Posar l'expansion tile aquí, i el botó de refresh si cal
//TODO: Segurament seria millor que aquí no hi hagués el listloader, sinó que partís de una llista, si cal es pot crear un altre component per fer

  @override
  Widget build(BuildContext context) {
    return ListLoader<T>(
      key: _listLoaderKey,
      getStream: getStream,
      builder: (items, loading) {
        return Column(
          children: <Widget>[
            if (loading) Container(child: LinearProgressIndicator()),
            Expanded(
              child: DynamicList<T>(
                items: items,
                itemTitle: itemTitle,
                itemSubtitle: itemSubtitle,
                itemLeading: itemLeading,
                itemTrailing: itemTrailing,
                //select: select,
              ),
            ),
          ],
        );
      },
    );
  }
}
