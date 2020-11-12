import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

//T tipus de dades de la llista
class DynamicList<T> extends StatelessWidget {
  final List<T> items;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String> itemSubtitle;
  final FunctionOf1<T, Widget> itemLeading;
  final FunctionOf1<T, Widget> itemTrailing;
  final FunctionOf1<T, Future<void>> select;
  final ScrollController _scrollController = ScrollController();

//TODO: Potser seria bona idea que la càrrega estigués al BaseScaffold?
//i potser el loading fos part d'un model genèric? no sé si podrà ser

//TODO: Estaria bé que el conjunt de items estés particionat i que anés carregant més págines
//em farà falta aquesta informació:
//-https://codinglatte.com/posts/flutter/listview-infinite-scrolling-in-flutter/
//-https://www.codingame.com/playgrounds/5363/paging-with-entity-framework-core
//-https://www.sqlshack.com/pagination-in-sql-server/

  DynamicList({
    @required this.items,
    @required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.select,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (BuildContext ctx, int index) {
            if (index >= items.length) return SizedBox();
            final model = items[index];
            return ListTile(
              dense: false,
              title: Text(itemTitle(model)),
              subtitle: Text(itemSubtitle(model)),
              leading: itemLeading != null ? itemLeading(model) : null,
              trailing: itemTrailing != null ? itemTrailing(model) : null,
              onTap: () {
                if (select == null) return;
                select(model);
              },
            );
          }),
    );
  }
}
