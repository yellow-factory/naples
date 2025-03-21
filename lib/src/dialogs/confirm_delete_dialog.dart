import 'package:flutter/material.dart';

enum YesNoDialogOptions { yes, no }

class ConfirmDeleteDialog extends StatelessWidget {
  final String itemName;
  const ConfirmDeleteDialog({
    super.key,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: Text('Are you sure you want to delete the $itemName?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, YesNoDialogOptions.no),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, YesNoDialogOptions.yes),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

Future<YesNoDialogOptions> showConfirmDeleteDialog({
  required BuildContext context,
  required String itemName,
}) async {
  var dialogResult = await showDialog<YesNoDialogOptions>(
    context: context,
    builder: (BuildContext context) => ConfirmDeleteDialog(
      itemName: itemName,
    ),
  );
  return dialogResult ?? YesNoDialogOptions.no;
}
