import 'package:flutter/widgets.dart';

///A Widget to represent a Widget that can be expanded,
///has the information to be expanded, but it's not,
///in contraposition of Expanded
abstract class Expandable extends StatelessWidget {
  final int flex;
  Expandable({
    Key key,
    this.flex = 1,
  }) : super(key: key);
}
