import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';

class ContainerProperty extends StatelessWidget implements Expandable {
  @override
  final int flex;
  final Widget child;

  const ContainerProperty({
    super.key,
    required this.child,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: child,
    );
  }
}
