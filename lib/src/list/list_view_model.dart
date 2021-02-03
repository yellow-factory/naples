import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/list.dart' as naples;
import 'package:naples/src/common/loading.dart';
import 'package:naples/src/widgets/async_action_icon_button.dart';
import 'package:navy/navy.dart';

//T tipus de dades de la llista
class ListViewModel<T> extends StatefulWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf1<int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;
  final FunctionOf1<T, Future<void>> select;
  final FunctionOf0<Future<void>> create;
  final Widget header;
  final List<Widget> actions;

//TODO: Els botons de filtre i refresh, quan està carregant haurien d'estar deshabilitats

//TODO: Potser seria bona idea que la càrrega estigués al BaseScaffold?
//i potser el loading fos part d'un model genèric? no sé si podrà ser

//TODO: Estaria bé que el conjunt de items estés particionat i que anés carregant més págines
//em farà falta aquesta informació:
//-https://codinglatte.com/posts/flutter/listview-infinite-scrolling-in-flutter/
//-https://www.codingame.com/playgrounds/5363/paging-with-entity-framework-core
//-https://www.sqlshack.com/pagination-in-sql-server/

//TODO: S'hauria de dir alguna cosa com ListScaffold

  ListViewModel({
    @required this.getStream,
    @required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.title,
    this.select,
    this.create,
    this.header,
    this.actions,
    Key key,
  }) : super(key: key);

  @override
  ListViewModelState<T> createState() => ListViewModelState<T>();
}

class ListViewModelState<T> extends State<ListViewModel<T>> {
  GlobalKey<naples.ListViewState<T>> _listViewKey;
  int _length = 0;

  @override
  void initState() {
    super.initState();
    _listViewKey = GlobalKey();
  }

  void filterBy(String filterBy) {
    if (_listViewKey.currentState == null) return;
    _listViewKey.currentState.filterValue = filterBy;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<naples.LengthNotification>(
      onNotification: (notification) {
        scheduleMicrotask(() {
          setState(() {
            _length = notification.length;
          });
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.title == null ? null : Text(widget.title(_length)),
          actions: <Widget>[
            if (widget.actions != null) ...widget.actions,
            AsyncActionIconButtonWidget(
              Icons.refresh,
              () async {
                _listViewKey.currentState.refresh();
              },
              message: "Refreshed!!",
            ),
          ],
        ),
        body: Loading(
          child: naples.ListView<T>(
            key: _listViewKey,
            getStream: widget.getStream,
            itemTitle: widget.itemTitle,
            itemSubtitle: widget.itemSubtitle,
            itemLeading: widget.itemLeading,
            itemTrailing: widget.itemTrailing,
            select: widget.select,
            header: widget.header,
          ),
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
      ),
    );
  }
}
