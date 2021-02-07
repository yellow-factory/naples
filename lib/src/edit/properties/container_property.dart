import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';

class ContainerProperty extends StatelessWidget implements Expandable {
  final int flex;
  final Widget child;

  ContainerProperty({
    Key key,
    @required this.child,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }
}
