import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/dialogs.dart';
import 'package:naples/list.dart';
import 'package:naples/src/generated/l10n/naples_localizations.dart';
import 'package:navy/navy.dart';

class CollectionEditor<ListItem> extends StatefulWidget implements Expandable {
  final FunctionOf0<String>? title;
  final FunctionOf0<String>? subtitle;
  @override
  final int flex;
  final List<ListItem> items;
  final FunctionOf1<ListItem, String> itemTitle;
  final FunctionOf1<ListItem, String>? itemSubtitle;

  final FunctionOf1<ListItem, Widget> updateWidget;
  final PredicateOf0 update;

  final Future<({Widget widget, String? title})?>  Function()? createWidget;
  final PredicateOf0? create;

  final ActionOf1<ListItem>? delete;

  final PredicateOf0? editable;

  final FunctionOf1<ListItem, String>? itemDialogTitle;

  const CollectionEditor({
    this.title,
    this.subtitle,
    required this.items,
    required this.itemTitle,
    this.itemSubtitle,
    required this.updateWidget,
    required this.update,
    this.createWidget,
    this.create,
    this.delete,
    this.flex = 1,
    this.editable,
    this.itemDialogTitle,
    super.key,
  });

  @override
  CollectionEditorState<ListItem> createState() => CollectionEditorState<ListItem>();

  bool get existCreate =>
      create != null && createWidget != null && (editable == null || editable!());
}

class CollectionEditorState<ListItem> extends State<CollectionEditor<ListItem>> {
  String _filterBy = '';

  @override
  Widget build(BuildContext context) {
    final l10n = NaplesLocalizations.of(context);
    final canEdit = widget.editable == null || widget.editable!();
    final hasHeader = widget.title != null || widget.subtitle != null;

    return Column(
      children: [
        if (hasHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Text(widget.title!(),
                            style: Theme.of(context).textTheme.titleMedium),
                      if (widget.subtitle != null)
                        Text(widget.subtitle!(),
                            style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                if (widget.existCreate)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: OutlinedButton.icon(
                      onPressed: _openCreateDialog,
                      icon: const Icon(Icons.add),
                      label: Text(l10n?.newItem ?? 'New'),
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n?.filterBy ?? 'Filter by',
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
            onChanged: (v) => setState(() => _filterBy = v),
          ),
        ),
        Expanded(
          child: FilterList<ListItem>(
            items: widget.items,
            filterBy: (item) {
              final filter = _filterBy.toLowerCase().trim();
              if (filter.isEmpty) return true;
              if (widget.itemTitle(item).toLowerCase().contains(filter)) return true;
              if (widget.itemSubtitle != null &&
                  widget.itemSubtitle!(item).toLowerCase().contains(filter)) {
                return true;
              }
              return false;
            },
            builder: (filtered) => DynamicList<ListItem>(
              items: filtered,
              itemTitle: widget.itemTitle,
              itemSubtitle: widget.itemSubtitle,
              separated: false,
              onlyShowItemTrailingOnHover: true,
              select: canEdit ? (item) => _openEditDialog(item) : null,
              itemTrailing: (widget.delete != null && canEdit)
                  ? (item) => IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(item),
                      )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openEditDialog(ListItem item) async {
    final editWidget = widget.updateWidget(item);
    await showDialog<void>(
      context: context,
      builder: (_) => _CollectionItemDialog(
        title: widget.itemDialogTitle?.call(item) ?? widget.title?.call() ?? '',
        onAccept: widget.update,
        child: editWidget,
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openCreateDialog() async {
    final widgetCreator = widget.createWidget;
    if (widgetCreator == null) return;
    final result = await widgetCreator();
    if (result == null) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _CollectionItemDialog(
        title: result.title ?? widget.title?.call() ?? '',
        onAccept: widget.create ?? () => true,
        child: result.widget,
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _confirmDelete(ListItem item) async {
    if (widget.delete == null) return;
    final result = await showConfirmDeleteDialog(
      context: context,
      itemName: widget.itemTitle(item),
    );
    if (result == YesNoDialogOptions.no) return;
    widget.delete!(item);
    if (mounted) setState(() {});
  }
}

class _CollectionItemDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final PredicateOf0 onAccept;

  const _CollectionItemDialog({
    required this.title,
    required this.child,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = NaplesLocalizations.of(context);
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: SizedBox(width: 400, child: child),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n?.cancel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (onAccept()) Navigator.pop(context);
          },
          child: Text(l10n?.accept ?? 'Accept'),
        ),
      ],
    );
  }
}
