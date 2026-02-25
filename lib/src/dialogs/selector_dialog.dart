import 'package:flutter/material.dart';
import 'package:naples/list.dart';
import 'package:naples/load.dart';
import 'package:navy/navy.dart';

class StreamSelectorDialog<T> extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final FunctionOf0<Stream<T>> getStream;
  final T? selectedItem;
  final FunctionOf1<T, String>? displayMember;

  const StreamSelectorDialog({
    super.key,
    this.title,
    this.subtitle,
    required this.getStream,
    this.selectedItem,
    this.displayMember,
  });

  @override
  Widget build(BuildContext context) {
    return ListLoader<T>(
      getStream: getStream,
      builder: (items) {
        return SelectorDialog<T>(
          title: title,
          subtitle: subtitle,
          items: items,
          selectedItem: selectedItem,
          displayMember: displayMember,
        );
      },
    );
  }
}

class _ClearedSentinel {
  const _ClearedSentinel();
}

const _clearedSentinel = _ClearedSentinel();

class SelectorDialog<T> extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final List<T> items;
  final T? selectedItem;
  final FunctionOf1<T, String>? displayMember;
  final bool clearable;

  const SelectorDialog({
    super.key,
    this.title,
    this.subtitle,
    required this.items,
    this.selectedItem,
    this.displayMember,
    this.clearable = false,
  });

  @override
  State<SelectorDialog<T>> createState() => SelectorDialogState<T>();
}

class SelectorDialogState<T> extends State<SelectorDialog<T>> {
  String _filterBy = "";

  @override
  Widget build(BuildContext context) {
    return FilterList<T>(
      items: widget.items,
      filterBy: (itemToFilter) {
        var curatedFilterBy = _filterBy.toLowerCase().trim();
        if (curatedFilterBy.isEmpty) return true;
        var itemToFilterString = widget.displayMember != null
            ? widget.displayMember!(itemToFilter)
            : itemToFilter.toString();
        return itemToFilterString.toLowerCase().trim().contains(curatedFilterBy);
      },
      builder: (filteredInstances) {
        return SimpleDialog(
          title: widget.title == null
              ? null
              : Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.title!),
                      subtitle: widget.subtitle == null ? null : Text(widget.subtitle!),
                      contentPadding: EdgeInsets.zero,
                      trailing: widget.clearable && widget.selectedItem != null
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Clear selection',
                              onPressed: () {
                                Navigator.pop(context, _clearedSentinel);
                              },
                            )
                          : null,
                    ),
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Filter by',
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        setState(() {
                          _filterBy = value;
                        });
                      },
                    ),
                  ],
                ),
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 400, minWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var instance in filteredInstances)
                    SimpleDialogOption(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.displayMember != null
                                  ? widget.displayMember!(instance)
                                  : instance.toString(),
                              style: widget.selectedItem == instance
                                  ? const TextStyle(fontWeight: FontWeight.bold)
                                  : null,
                            ),
                          ),
                          if (widget.selectedItem == instance) const Icon(Icons.check),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context, instance);
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

Future<T?> showStreamSelectDialog<T>({
  required BuildContext context,
  required Stream<T> items,
  String? title,
  String? subtitle,
  T? selectedItem,
  FunctionOf1<T, String>? displayMember,
}) async {
  var dialogResult = await showDialog<T>(
    context: context,
    builder: (context) {
      return StreamSelectorDialog<T>(
        title: title,
        subtitle: subtitle,
        getStream: () => items,
        selectedItem: selectedItem,
        displayMember: displayMember,
      );
    },
  );

  return dialogResult;
}

Future<T?> showSelectDialog<T>({
  required BuildContext context,
  required List<T> items,
  String? title,
  String? subtitle,
  T? selectedItem,
  FunctionOf1<T, String>? displayMember,
}) async {
  var dialogResult = await showDialog<T>(
    context: context,
    builder: (context) {
      return SelectorDialog<T>(
        title: title,
        subtitle: subtitle,
        items: items,
        selectedItem: selectedItem,
        displayMember: displayMember,
      );
    },
  );

  return dialogResult;
}

/// Shows a selection dialog with an optional "Clear selection" option.
///
/// Returns `(cleared: true, value: null)` when the user clears the selection,
/// `(cleared: false, value: T)` when an item is selected, and
/// `(cleared: false, value: null)` when the dialog is dismissed.
Future<({bool cleared, T? value})> showSelectDialogClearable<T>({
  required BuildContext context,
  required List<T> items,
  String? title,
  String? subtitle,
  T? selectedItem,
  FunctionOf1<T, String>? displayMember,
}) async {
  final result = await showDialog<Object?>(
    context: context,
    builder: (context) {
      return SelectorDialog<T>(
        title: title,
        subtitle: subtitle,
        items: items,
        selectedItem: selectedItem,
        displayMember: displayMember,
        clearable: true,
      );
    },
  );

  if (result == _clearedSentinel) return (cleared: true, value: null);
  if (result is T) return (cleared: false, value: result);
  return (cleared: false, value: null);
}
