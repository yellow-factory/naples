import 'package:flutter/material.dart';

abstract class ValidableState<T extends StatefulWidget> extends State<T> {
  bool get valid;
}
