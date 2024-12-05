import 'package:flutter/material.dart';
import 'package:naples/src/dialogs/confirm_delete_dialog.dart';
import 'package:naples/src/generated/l10n/naples_localizations.dart';
import 'package:navy/navy.dart';

enum AcceptCancelDeleteDialogOptions { accept, cancel, delete }

class AcceptCancelDeleteDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool valid; //Indicates if it's valid in the initial state
  final PredicateOf0? validate; //Function to validate the current child before select
  final bool showDelete;

  const AcceptCancelDeleteDialog({
    Key? key,
    required this.title,
    this.subtitle,
    required this.child,
    this.valid = true,
    this.validate,
    this.showDelete = false,
  }) : super(key: key);

  @override
  State<AcceptCancelDeleteDialog> createState() => _AcceptCancelDeleteDialogState();
}

class _AcceptCancelDeleteDialogState extends State<AcceptCancelDeleteDialog> {
  void _returnAccept() {
    if (!widget.valid) return;
    if (widget.validate != null && !widget.validate!()) return;
    Navigator.pop(context, AcceptCancelDeleteDialogOptions.accept);
  }

  void _returnCancel() {
    Navigator.pop(context, AcceptCancelDeleteDialogOptions.cancel);
  }

  void _confirmDelete() async {
    var dialogResult = await showConfirmDeleteDialog(
      context: context,
      itemName: widget.title,
    );
    if (dialogResult == YesNoDialogOptions.yes) {
      _returnDelete();
    }
  }

  void _returnDelete() {
    Navigator.pop(context, AcceptCancelDeleteDialogOptions.delete);
  }

  NaplesLocalizations get naplesLocalizations =>
      NaplesLocalizations.of(context) ??
      (throw Exception("NaplesLocalizations not found in the context"));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ListTile(
        title: Text(widget.title),
        subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
        contentPadding: EdgeInsets.zero,
        trailing: widget.showDelete
            ? IconButton(
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete),
              )
            : null,
      ),
      content: widget.child,
      actions: <Widget>[
        TextButton(
          onPressed: _returnCancel,
          child: Text(naplesLocalizations.cancel),
        ),
        TextButton(
          onPressed: _returnAccept,
          child: Text(naplesLocalizations.accept),
        ),
      ],
    );
  }
}
