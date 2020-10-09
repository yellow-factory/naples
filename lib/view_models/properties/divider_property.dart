import 'package:flutter/material.dart';
import 'package:navy/navy.dart';
import 'package:naples/view_models/view_model.dart';

class DividerProperty extends ViewProperty {
  DividerProperty({
    int flex = 99,
    PredicateOf0 isVisible,
  }) : super(
          flex: flex,
          isVisible: isVisible,
        );

  @override
  Widget get widget => Divider();

//TODO: Cal separar el widget com en la resta de casos
//TODO: Es podrien afegir algunes propietats per fer-lo més ric, com en el cas del CommentLayoutMember: topPadding, bottomPadding,etc.
  // const Divider(
  //           color: Colors.black,
  //           height: 20,
  //           thickness: 5,
  //           indent: 20,
  //           endIndent: 0,
  //         ),

}
