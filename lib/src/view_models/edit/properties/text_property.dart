import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

abstract class TextProperty<U> extends ModelProperty<U> {
  final bool obscureText;
  final int maxLength;

  TextProperty(
    FunctionOf0<U> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<U> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<U, String> isValid,
    this.obscureText: false,
    this.maxLength = -1,
  }) : super(
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  void initialize() {
    currentValue = getProperty();
  }

  String get serializedValue {
    if (currentValue == null) return '';
    return currentValue.toString();
  }

  set serializedValue(String value);
}
