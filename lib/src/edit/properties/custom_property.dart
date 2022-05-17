import 'package:flutter/material.dart';
import 'package:naples/src/dialogs/confirm_delete_dialog.dart';
import 'package:naples/src/dialogs/select_cancel_dialog.dart';
import 'package:naples/src/edit/valid_form.dart';

class CustomProperty extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: description),
        IconButton(
          onPressed: () {
            showConfirmCancelDialog(
              context: context,
              child: ValidForm(
                validateOnFormChanged: true,
                //saveOnFormChanged: false,
                builder: (validformstate) {
                  return SelectCancelDialog(
                    title: name,
                    valid: validformstate.valid,
                    validate: validformstate.validate,
                    child: validformstate.form,
                  );
                },
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 300,
                    child: editContent,
                  ),
                ),
              ),
              confirmAction: () {
                set();
              },
            );
          },
          icon: const Icon(Icons.edit),
        ),
        if (delete != null)
          IconButton(
            onPressed: () {
              showConfirmDeleteDialog(
                  context: context,
                  itemName: name,
                  deleteAction: () {
                    delete!();
                  });
            },
            icon: const Icon(Icons.delete),
          ),
      ],
    );
  }
}
