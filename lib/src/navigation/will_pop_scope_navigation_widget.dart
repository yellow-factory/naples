import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';

class WillPopScopeNavigationWidget extends StatelessWidget {
  final Widget child;
  final NavigationModel navigationModel;
  const WillPopScopeNavigationWidget({
    super.key,
    required this.child,
    required this.navigationModel,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return; // Already popped by framework.
        try {
          final handled = navigationModel.back();
          if (handled) {
            return; // consumed
          }
          Navigator.maybePop(context, result);
        } catch (_) {
          // ignore
        }
      },
      child: child,
    );
  }
}
