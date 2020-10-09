import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

abstract class ViewProperty extends ChangeNotifier {
  final int flex;
  final PredicateOf0 isVisible;

  ViewProperty({this.flex = 1, this.isVisible});

  Widget get widget;
}
