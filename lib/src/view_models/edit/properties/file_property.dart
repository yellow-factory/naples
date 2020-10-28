import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/widgets/file_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

class FileProperty extends ModelProperty<List<int>> {
  FileProperty({
    @required FunctionOf0<List<int>> getProperty,
    String label,
    String hint,
    int flex,
    bool autofocus = false,
    ActionOf1<List<int>> setProperty,
    PredicateOf0 isEditable,
  }) : super(
          getProperty: getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isEditable: isEditable,
        );

  @override
  Widget build(BuildContext context) {
    return FileViewModelPropertyWidget(
      label: label,
      hint: hint,
    );
  }
}
