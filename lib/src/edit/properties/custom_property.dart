import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naples/src/dialogs/accept_cancel_delete_dialog.dart';
import 'package:navy/navy.dart';

class CustomProperty extends StatefulWidget {
  final String name;
  final FunctionOf0<Future<String>> description;
  final Widget editContent;
  final double editContentWidth;
  final Function set;
  final Function? delete;
  const CustomProperty({
    Key? key,
    required this.name,
    required this.description,
    required this.editContent,
    this.editContentWidth = 300,
    required this.set,
    this.delete,
  }) : super(key: key);

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
    _descriptionController.text = '';
  }

  Future<void> _set() async {
    _formKey.currentState?.save();
    widget.set();
    _descriptionController.text = await widget.description();
  }

  Future<void> _showSelectDialog() async {
    var dialogResult = await showDialog<AcceptCancelDeleteDialogOptions>(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AcceptCancelDeleteDialog(
            title: widget.name,
            showDelete: widget.delete != null,
            validate: () => _formKey.currentState?.validate() ?? true,
            child: SingleChildScrollView(
              child: SizedBox(
                width: widget.editContentWidth,
                child: widget.editContent,
              ),
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
        _set();
        break;
      default:
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
        labelText: widget.name,
        suffixIcon: IconButton(
          onPressed: _showSelectDialog,
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
