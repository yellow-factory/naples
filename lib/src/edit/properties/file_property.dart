import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/edit/properties/widgets/file_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class FileProperty extends StatelessWidget with ModelProperty<List<int>>, Expandable {
  final int flex;
  final String label;
  final String hint;
  final bool autofocus;
  final PredicateOf0 editable;
  final FunctionOf0<List<int>> getProperty;
  final ActionOf1<List<int>> setProperty;
  final FunctionOf1<List<int>, String> validator;

  FileProperty({
    Key key,
    this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    @required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FileWidget(
      label: label,
      hint: hint,
    );
  }
}
