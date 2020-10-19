import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:navy/navy.dart';

//T tipus de dades de la llista
class DynamicList<T> extends StatelessWidget {
  final List<T> items;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Future<void>> select;
  final ScrollController _scrollController = ScrollController();

//TODO: Potser seria bona idea que la càrrega estigués al BaseScaffold?
//i potser el loading fos part d'un model genèric? no sé si podrà ser

//TODO: Estaria bé que el conjunt de items estés particionat i que anés carregant més págines
//em farà falta aquesta informació:
//-https://codinglatte.com/posts/flutter/listview-infinite-scrolling-in-flutter/
//-https://www.codingame.com/playgrounds/5363/paging-with-entity-framework-core
//-https://www.sqlshack.com/pagination-in-sql-server/

  DynamicList(
    this.items,
    this.itemTitle, {
    this.itemSubtitle,
    this.select,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (BuildContext ctx, int index) {
            if (index >= items.length) return Container();
            final model = items[index];
            return Card(
              child: ListTile(
                dense: false,
                title: Text(itemTitle(model)),
                subtitle: Text(itemSubtitle(model)),
                leading: FaIcon(FontAwesomeIcons.table, size: 50.0),
                trailing: Icon(Icons.more_vert),
                onTap: () {
                  if (select == null) return;
                  select(model);
                },
              ),
            );
          }),
    );
  }
}
