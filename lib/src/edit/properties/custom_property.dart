import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/src/dialogs/accept_cancel_delete_dialog.dart';
import 'package:navy/navy.dart';

class CustomProperty extends StatefulWidget {
  final String title;
  final String? subtitle;
  final FunctionOf0<FutureOr<String>> description;
  final Widget editContent;
  final double editContentWidth;
  final Function set;
  final Function? delete;
  final PredicateOf0? editable;
  const CustomProperty({
    super.key,
    required this.title,
    this.subtitle,
    required this.description,
    required this.editContent,
    this.editContentWidth = 300,
    required this.set,
    this.delete,
    this.editable,
  });

  @override
  State<CustomProperty> createState() => _CustomPropertyState();
}

class _CustomPropertyState extends State<CustomProperty> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initDescription();
  }

  Future<void> initDescription() async {
    _descriptionController.text = await widget.description();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    await widget.delete!();
    if (mounted) _descriptionController.text = '';
  }

  Future<void> _set() async {
    _formKey.currentState?.save();
    widget.set();
    if (mounted) _descriptionController.text = await widget.description();
  }

  Future<void> _showSelectDialog() async {
    var dialogResult = await showDialog<AcceptCancelDeleteDialogOptions>(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AcceptCancelDeleteDialog(
            title: widget.title,
            subtitle: widget.subtitle,
            showDelete: widget.delete != null,
            validate: () => _formKey.currentState?.validate() ?? true,
            child: SingleChildScrollView(
              child: SizedBox(width: widget.editContentWidth, child: widget.editContent),
            ),
          ),
        );
      },
    );
    _executeDialogResult(dialogResult ?? AcceptCancelDeleteDialogOptions.cancel);
  }

  Future<void> _executeDialogResult(AcceptCancelDeleteDialogOptions result) async {
    switch (result) {
      case AcceptCancelDeleteDialogOptions.delete:
        await _delete();
        break;
      case AcceptCancelDeleteDialogOptions.accept:
        await _set();
        break;
      case AcceptCancelDeleteDialogOptions.cancel:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
      readOnly: true,
      enabled: true,
      autofocus: false,
      decoration: InputDecoration(
        labelText: widget.title,
        suffixIcon:
            (widget.editable ?? () => true)()
                ? IconButton(onPressed: _showSelectDialog, icon: const Icon(Icons.edit))
                : null,
      ),
    );
  }
}

//TODO: Cal repensar si cal que hi hagi un Form i si TextFormField pot ser simplement TextField
