import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/list.dart';
import 'package:naples/src/view_models/list/list_loader.dart';
import 'package:naples/widgets/async_action_icon_button.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:navy/navy.dart';

//T tipus de dades de la llista
class ListViewModel<T> extends StatelessWidget {
  final FunctionOf0<Stream<T>> getStream;
  final FunctionOf2<BuildContext, int, String> title;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Future<void>> select;
  final FunctionOf0<Future<void>> create;

//TODO: Els botons de filtre i refresh, quan està carregant haurien d'estar deshabilitats

//TODO: Potser seria bona idea que la càrrega estigués al BaseScaffold?
//i potser el loading fos part d'un model genèric? no sé si podrà ser

//TODO: Estaria bé que el conjunt de items estés particionat i que anés carregant més págines
//em farà falta aquesta informació:
//-https://codinglatte.com/posts/flutter/listview-infinite-scrolling-in-flutter/
//-https://www.codingame.com/playgrounds/5363/paging-with-entity-framework-core
//-https://www.sqlshack.com/pagination-in-sql-server/

  ListViewModel({
    @required this.getStream,
    @required this.itemTitle,
    this.itemSubtitle,
    this.title,
    this.select,
    this.create,
    Key key,
  }) : super(key: key);

  final _listLoaderKey = GlobalKey<ListLoaderState<T>>();

//TODO; The loading is a good case for the notofication system

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      child: ListLoader<T>(
        key: _listLoaderKey,
        getStream: getStream,
        builder: (items, loading) => Column(
          children: <Widget>[
            if (loading) Container(child: LinearProgressIndicator()),
            Expanded(
              child: BaseListViewModel<T>(
                items,
                itemTitle,
                itemSubtitle: itemSubtitle,
                select: select,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        AsyncActionIconButton(
          Icons.refresh,
          () async {
            await _listLoaderKey.currentState.refresh();
          },
          message: (c) => "Refreshed!!",
        ),
      ],
      floatingAction: create == null
          ? null
          : FloatingActionButton(
              onPressed: () async {
                await create();
              },
              tooltip: 'New model', //TODO: Això s'hauria de parametritzar, i l'icona també?
              child: Icon(Icons.add),
            ),
      padding: 0,
    );
  }
}
