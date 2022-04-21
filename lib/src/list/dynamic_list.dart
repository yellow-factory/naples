import 'package:flutter/material.dart';
import 'package:naples/src/widgets/onhover.dart';
import 'package:navy/navy.dart';

//TODO: S'hauria de poder mantenir un element seleccionat i per fer-ho cal convertir-lo a Stateful

//T tipus de dades de la llista
class DynamicList<T> extends StatelessWidget {
  final List<T> items;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String>? itemSubtitle;
  final FunctionOf1<T, Widget>? itemLeading;
  final FunctionOf1<T, Widget>? itemTrailing;
  final bool onlyShowItemTrailingOnHover;
  final FunctionOf1<T, Future<void>>? select;
  final bool separated;
  final ScrollController _scrollController = ScrollController();

  DynamicList({
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.onlyShowItemTrailingOnHover = false,
    this.select,
    this.separated = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
          itemExtent: _tileHeight(context),
          controller: _scrollController,
          itemCount: items.length,
          itemBuilder: (BuildContext ctx, int index) {
            if (index >= items.length) return SizedBox();
            final model = items[index];
            return Column(
              children: [
                OnHoverWidget(
                  builder: (hover) {
                    return ListTile(
                      dense: false,
                      title: Text(
                        itemTitle(model),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: itemSubtitle != null
                          ? Text(
                              itemSubtitle!(model),
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      leading: itemLeading != null ? itemLeading!(model) : null,
                      trailing: itemTrailing != null
                          ? onlyShowItemTrailingOnHover == false ||
                                  onlyShowItemTrailingOnHover && hover
                              ? itemTrailing!(model)
                              : null
                          : null,
                      onTap: () {
                        if (select == null) return;
                        select!(model);
                      },
                    );
                  },
                ),
                if (separated)
                  Divider(
                    height: _defaultDividerHeight(context),
                  ),
              ],
            );
          }),
    );
  }

  double _tileHeight(BuildContext context) {
    double result = _defaultTileHeight(context);
    if (separated) result += _defaultDividerHeight(context);
    return result;
  }

  double _defaultDividerHeight(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    return dividerTheme.space ?? 1.0;
  }

  double _defaultTileHeight(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isThreeLine = false;
    //final bool isDense = false;
    final bool hasSubtitle = this.itemSubtitle != null;
    final bool isTwoLine = !isThreeLine && hasSubtitle;
    final bool isOneLine = !isThreeLine && !hasSubtitle;

    final Offset baseDensity = theme.visualDensity.baseSizeAdjustment;
    if (isOneLine) return 56.0 + baseDensity.dy;
    //return (isDense ? 48.0 : 56.0) + baseDensity.dy;
    if (isTwoLine) return 72.0 + baseDensity.dy;
    //if (isTwoLine) return (isDense ? 64.0 : 72.0) + baseDensity.dy;
    //return (isDense ? 76.0 : 88.0) + baseDensity.dy;
    return 88.0 + baseDensity.dy;
  }
}
