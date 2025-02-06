import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';

class DividerProperty extends StatelessWidget implements Expandable {
  @override
  final int flex;
  const DividerProperty({
    super.key,
    this.flex = 99,
  });

  @override
  Widget build(BuildContext context) => const Divider();

//TODO: Es podrien afegir algunes propietats per fer-lo més ric, com en el cas del CommentLayoutMember: topPadding, bottomPadding,etc.
  // const Divider(
  //           color: Colors.black,
  //           height: 20,
  //           thickness: 5,
  //           indent: 20,
  //           endIndent: 0,
  //         ),
}
