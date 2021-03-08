import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';

class ExpandableProperty extends StatelessWidget implements Expandable {
  final int flex;
  final String label;
  final Widget child;
  final double expandedHeight;

  ExpandableProperty({
    Key? key,
    required this.label,
    required this.child,
    this.flex = 1,
    this.expandedHeight = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
        ],
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      initiallyExpanded: false,
      backgroundColor: Colors.grey[200],
      children: [
        //child
        SizedBox(height: expandedHeight, child: child),
      ],
    );
  }
}
