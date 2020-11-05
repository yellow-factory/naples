import 'package:flutter/material.dart';

///State for a StatefulWidget that has a boolean valid property
abstract class ValidableState<T extends StatefulWidget> extends State<T> {
  bool get valid;
}

///Interface to implement in a Widget that can be expanded,
///has the information to be expanded
abstract class Expandable {
  int get flex;
}
