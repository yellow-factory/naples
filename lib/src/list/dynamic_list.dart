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
              subtitle: itemSubtitle != null ? Text(itemSubtitle(model)) : null,
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
