import 'package:flutter/material.dart';
import 'package:naples/widgets/expandable.dart';

class DividerProperty extends Expandable {
  DividerProperty({
    Key key,
    int flex = 99,
  }) : super(key: key, flex: flex);

  @override
  Widget build(BuildContext context) => Divider();

//TODO: Es podrien afegir algunes propietats per fer-lo més ric, com en el cas del CommentLayoutMember: topPadding, bottomPadding,etc.
  // const Divider(
  //           color: Colors.black,
  //           height: 20,
  //           thickness: 5,
  //           indent: 20,
  //           endIndent: 0,
  //         ),

}
