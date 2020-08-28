import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:provider/provider.dart';

class DynamicListWidget extends StatelessWidget {
  DynamicListWidget({Key key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

//TODO: Els botons de filtre i refresh, quan està carregant haurien d'estar deshabilitats

//TODO: Potser seria bona idea que la càrrega estigués al BaseScaffold?
//i potser el loading fos part d'un model genèric? no sé si podrà ser

//TODO: Estaria bé que el conjunt de items estés particionat i que anés carregant més págines
//em farà falta aquesta informació:
//-https://codinglatte.com/posts/flutter/listview-infinite-scrolling-in-flutter/
//-https://www.codingame.com/playgrounds/5363/paging-with-entity-framework-core
//-https://www.sqlshack.com/pagination-in-sql-server/

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<ListViewModel>();
    return Column(children: <Widget>[
      if (viewModel.loading) Container(child: LinearProgressIndicator()),
      Expanded(
          child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: viewModel.items.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    if (index >= viewModel.items.length) return null;
                    final model = viewModel.items[index];
                    return Card(
                        child: ListTile(
                      dense: false,
                      title: Text(viewModel.itemTitle(model)),
                      subtitle: Text(viewModel.itemSubtitle(model)),
                      leading: FaIcon(FontAwesomeIcons.table, size: 50.0),
                      trailing: Icon(Icons.more_vert),
                      onTap: () {
                        viewModel.select(model);
                      },
                    ));
                  })))
    ]);
  }
}
