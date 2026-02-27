import 'package:flutter/material.dart';
import 'package:naples/src/generated/l10n/naples_localizations.dart';

enum YesNoDialogOptions { yes, no }

class ConfirmDeleteDialog extends StatelessWidget {
  final String itemName;
  const ConfirmDeleteDialog({
    super.key,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    final l = NaplesLocalizations.of(context) ??
        (throw Exception("NaplesLocalizations not found in the context"));
    return AlertDialog(
      title: Text(l.delete),
      content: Text(l.confirmDeleteMessage(itemName)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, YesNoDialogOptions.no),
          child: Text(l.no),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, YesNoDialogOptions.yes),
          child: Text(l.yes),
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
