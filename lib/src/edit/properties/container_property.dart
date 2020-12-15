import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';

class ContainerProperty extends StatelessWidget implements Expandable {
  final int flex;
  final String label;
  final Widget child;

  ContainerProperty({
    Key key,
    @required this.label,
    @required this.child,
    this.flex = 1,
    PredicateOf0 isEditable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      tilePadding: EdgeInsets.symmetric(vertical: 10),
      initiallyExpanded: false,
      // trailing: IconButton(
      //   icon: Icon(Icons.create),
      //   onPressed: () {},
      // ),
      backgroundColor: Colors.grey[200],
      children: [
        SizedBox(height: 400, child: child),
      ],
    );
  }
}
