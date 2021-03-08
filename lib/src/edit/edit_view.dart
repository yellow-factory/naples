import 'package:flutter/material.dart';
import 'package:naples/widgets.dart';
import 'package:navy/navy.dart';

class EditView extends StatelessWidget {
  final ActionOf0 save;
  final ActionOf0 cancel;
  final String saveText;
  final String cancelText;
  final Widget child;
  final bool valid;

  EditView({
    required this.save,
    required this.cancel,
    required this.saveText,
    required this.cancelText,
    required this.child,
    this.valid = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          child,
          ActionsListWidget(
            actions: <ActionWidget>[
              ActionWidget(
                title: saveText,
                action: !valid ? null : save,
                primary: true,
              ),
              ActionWidget(
                title: cancelText,
                action: cancel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
