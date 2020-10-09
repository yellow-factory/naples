import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/widgets/file_view_model_property_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/view_models/view_model.dart';
import 'package:provider/provider.dart';

class FileProperty extends ModelProperty<List<int>> {
  List<int> _value;

  FileProperty(
    FunctionOf0<List<int>> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex,
    bool autofocus = false,
    ActionOf1<List<int>> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
  }) : super(
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
        );

  @override
  List<int> get currentValue => _value;

  @override
  void initialize() {
    _value = getProperty();
  }

  @override
  Widget get widget {
    return ChangeNotifierProvider<FileProperty>.value(
        value: this, child: FileViewModelPropertyWidget());
  }
}
