import 'package:flutter/material.dart';
import 'package:naples/src/generated/l10n/naples_localizations.dart';

class CloseDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const CloseDialog({super.key, required this.title, this.subtitle, required this.child});

  @override
  State<CloseDialog> createState() => _CloseDialogState();
}

class _CloseDialogState extends State<CloseDialog> {
  void _returnClose() {
    Navigator.pop(context);
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
        //trailing: IconButton(onPressed: _returnClose, icon: const flutteIcon(Icons.close)),
      ),
      content: widget.child,
      actions: <Widget>[
        TextButton(onPressed: _returnClose, child: Text(naplesLocalizations.close)),
      ],
    );
  }
}
