import 'package:flutter/material.dart';
import 'package:naples/src/widgets/onhover.dart';
import 'package:navy/navy.dart';

//TODO: S'hauria de poder mantenir un element seleccionat

//T tipus de dades de la llista
class DynamicList<T> extends StatefulWidget {
  final List<T> items;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String>? itemSubtitle;
  final FunctionOf1<T, Widget>? itemLeading;
  final FunctionOf1<T, Widget>? itemTrailing;
  final FunctionOf1<T, Color?>? itemTileColor;
  final bool onlyShowItemTrailingOnHover;
  final FunctionOf1<T, Future<void>>? select;
  final bool separated;
  final bool dense;

  const DynamicList({
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    this.itemLeading,
    this.itemTrailing,
    this.itemTileColor,
    this.onlyShowItemTrailingOnHover = false,
    this.select,
    this.separated = false,
    this.dense = false,
    super.key,
  });

  @override
  State<DynamicList<T>> createState() => _DynamicListState<T>();
}

class _DynamicListState<T> extends State<DynamicList<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctx, int index) {
          if (index >= widget.items.length) return const SizedBox();
          final model = widget.items[index];
          return Column(
            children: [
              OnHoverWidget(
                builder: (hover) {
                  return ListTile(
                    dense: widget.dense,
                    tileColor: widget.itemTileColor?.call(model),
                    title: Text(widget.itemTitle(model), overflow: TextOverflow.ellipsis),
                    subtitle: widget.itemSubtitle != null
                        ? Text(widget.itemSubtitle!(model), overflow: TextOverflow.ellipsis)
                        : null,
                    leading: widget.itemLeading != null ? widget.itemLeading!(model) : null,
                    trailing: widget.itemTrailing != null
                        ? widget.onlyShowItemTrailingOnHover == false ||
                                  widget.onlyShowItemTrailingOnHover && hover
                              ? widget.itemTrailing!(model)
                              : null
                        : null,
                    onTap: () {
                      if (widget.select == null) return;
                      widget.select!(model);
                    },
                  );
                },
              ),
              if (widget.separated) Divider(height: _defaultDividerHeight(context)),
            ],
          );
        },
      ),
    );
  }

  double _defaultDividerHeight(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    return dividerTheme.space ?? 1.0;
  }
}
