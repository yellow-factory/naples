import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

enum SelectCancelDialogOptions { select, cancel }

//TODO: Arreglar els textos per tal que estiguin dins de l'enum i localitzables

String selectOptionText(BuildContext context) => "Select";
String cancelOptionText(BuildContext context) => "Cancel";

//https://stackoverflow.com/questions/58977815/flutter-setstate-on-showdialog

class SelectCancelDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final bool valid; //Indicates if it's valid in the initial state
  final PredicateOf0? validate; //Function to validate the current child before select

  const SelectCancelDialog({
    Key? key,
    required this.title,
    required this.child,
    this.valid = true,
    this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: child,
      actions: <Widget>[
        TextButton(
          child: Text(cancelOptionText(context)),
          onPressed: () => Navigator.pop(context, SelectCancelDialogOptions.cancel),
        ),
        TextButton(
          onPressed: valid
              ? () {
                  if (validate != null && !validate!()) return;
                  Navigator.pop(context, SelectCancelDialogOptions.select);
                }
              : null,
          child: Text(selectOptionText(context)),
        ),
      ],
    );
  }
}

void showConfirmCancelDialog({
  required BuildContext context,
  required Widget child,
  required Function confirmAction,
}) async {
  var dialogResult = await showDialog<SelectCancelDialogOptions>(
    context: context,
    builder: (BuildContext context) {
      return child;
    },
  );
  if (dialogResult == SelectCancelDialogOptions.select) {
    confirmAction();
  }
}
