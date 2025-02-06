import 'package:flutter/material.dart';
import 'package:naples/widgets.dart';
import 'package:navy/navy.dart';

class EditView extends StatelessWidget {
  final ActionOf0 save;
  final ActionOf0? cancel;
  final String saveText;
  final String cancelText;
  final Widget child;
  final String? savedMessage;
  final bool valid;
  final bool goBack;

  const EditView({
    required this.save,
    this.cancel,
    this.saveText = "Save", //TODO: Localize
    this.cancelText = "Cancel", //TODO: Localize
    required this.child,
    this.savedMessage,
    this.valid = true,
    this.goBack = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          child,
          ActionsListWidget(
            actions: <ActionWidget>[
              ActionWidget(
                title: saveText,
                action: () async {
                  if (!valid) return;
                  save();
                  if (goBack) Navigator.pop(context);
                  ifNotNullActionOf1(savedMessage, (String sm) {
                    if (sm.isEmpty) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(sm),
                      ),
                    );
                  });
                },
                primary: true,
              ),
              if (cancel != null)
                ActionWidget(
                  title: cancelText,
                  action: () async {
                    cancel!();
                    if (goBack) Navigator.pop(context);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
