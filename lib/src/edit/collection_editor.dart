//We need a collection editor

import 'package:flutter/material.dart';
import 'package:naples/list.dart';

//Combination of ExpandableList + Edit to edit a collection of items...
//Where T is type parent holding the collection
//Where U is the type of the items in the collection
//Is T needed? or we can just have a collection of U
class CollectionEditor<T> extends StatelessWidget {
  //TODO: We will need a function to retrieve the collection from T

  //final MetadataService listService;
  final List<T> collection;

  CollectionEditor(this.collection, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var listService = context.watch<ListStandardService<Model>>();
    //var navigationModel = context.watch<NavigationModel<StandardFlow>>();
    return Row(
      children: [
        // ExpandableList<T>(
        //   title: (count) => "Properties ${count > 0 ? '(count: $count)' : ''}",
        //   getStream: listService.list,
        //   itemTitle: (x) => x.name,
        //   //itemSubtitle: (x) => x.description
        //   // itemLeading: FaIcon(FontAwesomeIcons.table, size: 50.0),
        //   // itemTrailing: Icon(Icons.more_vert),
        //   // select: (T itemToSelect) async {
        //   //   //Registers the value for side/next view
        //   //   final ValueNotifier<U> param = context.read<ValueNotifier<U>>();
        //   //   param.value = keySelector(itemToSelect);
        //   //   //Executes navigation to the next view
        //   //   //TODO: add an option to throw if not transitioned (on transition method)
        //   //   var transitioned = await navigationModel.transition(StandardFlow.Update);
        //   //   if (!transitioned) print('The transition has not been succesful!');
        //   // },
        //   // create: () async {
        //   //   var transitioned = await navigationModel.transition(StandardFlow.Create);
        //   //   if (!transitioned) print('The transition has not been succesful!');
        //   // },
        // ),
        Card(
          child: Text('hola'),
        ),
      ],
    );
  }
}
