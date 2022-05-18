import 'package:flutter/material.dart';
import 'package:naples/edit.dart';
import 'package:naples/src/dialogs/confirm_delete_dialog.dart';
import 'package:naples/src/dialogs/select_cancel_dialog.dart';

class CustomProperty extends StatefulWidget {
  final String name;
  final Widget description;
  final Widget editContent;
  final Function set;
  final Function? delete;
  const CustomProperty({
    Key? key,
    required this.name,
    required this.description,
    required this.editContent,
    required this.set,
    this.delete,
  }) : super(key: key);

  @override
  State<CustomProperty> createState() => _CustomPropertyState();
}

class _CustomPropertyState extends State<CustomProperty> {
  ValidFormState? _validFormState;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: widget.description),
        IconButton(
          onPressed: () {
            showConfirmCancelDialog(
              context: context,
              child: ValidForm(
                  child: widget.editContent,
                  builder: (validFormState) {
                    _validFormState = validFormState;
                    return SelectCancelDialog(
                      title: widget.name,
                      valid: validFormState.valid,
                      validate: validFormState.validate,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: 300,
                          child: validFormState.form,
                        ),
                      ),
                    );
                  }),
              confirmAction: () {
                _validFormState?.formState?.save();
                widget.set();
              },
            );
          },
          icon: const Icon(Icons.edit),
        ),
        if (widget.delete != null)
          IconButton(
            onPressed: () {
              showConfirmDeleteDialog(
                  context: context,
                  itemName: widget.name,
                  deleteAction: () {
                    widget.delete!();
                  });
            },
            icon: const Icon(Icons.delete),
          ),
      ],
    );
  }
}
