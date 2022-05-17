import 'package:flutter/material.dart';

enum YesNoDialogOptions { yes, no }

class ConfirmDeleteDialog extends StatelessWidget {
  final String itemName;
  const ConfirmDeleteDialog({
    Key? key,
    required this.itemName,
  }) : super(key: key);

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

void showConfirmDeleteDialog(
    {required BuildContext context,
    required String itemName,
    required Function deleteAction}) async {
  var dialogResult = await showDialog<YesNoDialogOptions>(
    context: context,
    builder: (BuildContext context) => ConfirmDeleteDialog(
      itemName: itemName,
    ),
  );
  if (dialogResult == YesNoDialogOptions.yes) {
    deleteAction();
  }
}
