import 'package:flutter/material.dart';
import 'package:naples/list.dart';
import 'package:naples/load.dart';
import 'package:navy/navy.dart';

class StreamSelectorDialog<T> extends StatelessWidget {
  final String? title;
  final FunctionOf0<Stream<T>> getStream;

  const StreamSelectorDialog({
    super.key,
    required this.title,
    required this.getStream,
  });

  @override
  Widget build(BuildContext context) {
    return ListLoader<T>(
      getStream: getStream,
      builder: (items) {
        return SelectorDialog<T>(
          title: title,
          items: items,
        );
      },
    );
  }
}

class SelectorDialog<T> extends StatefulWidget {
  final String? title;
  final List<T> items;

  const SelectorDialog({
    super.key,
    required this.title,
    required this.items,
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
        return itemToFilter.toString().toLowerCase().trim().contains(curatedFilterBy);
      },
      builder: (filteredInstances) {
        return SimpleDialog(
          title: widget.title != null ? Text(widget.title!) : null,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'Filter by', contentPadding: EdgeInsets.only(left: 10)),
                style: const TextStyle(fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    _filterBy = value;
                  });
                },
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 400, minWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var instance in filteredInstances)
                    SimpleDialogOption(
                      child: Text(instance.toString()),
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
}) async {
  var dialogResult = await showDialog<T>(
    context: context,
    builder: (context) {
      return StreamSelectorDialog<T>(
        title: title,
        getStream: () => items,
      );
    },
  );

  return dialogResult;
}

Future<T?> showSelectDialog<T>({
  required BuildContext context,
  required List<T> items,
  String? title,
}) async {
  var dialogResult = await showDialog<T>(
    context: context,
    builder: (context) {
      return SelectorDialog<T>(
        title: title,
        items: items,
      );
    },
  );

  return dialogResult;
}
