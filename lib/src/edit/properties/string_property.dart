import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class StringProperty extends StatelessWidget with ModelProperty<String?>, Expandable {
  final int flex;
  final String label;
  final String? hint;
  final bool autofocus;
  final PredicateOf0? editable;
  final FunctionOf0<String?> getProperty;
  final ActionOf1<String?>? setProperty;
  final FunctionOf1<String?, String?>? validator;
  final bool obscureText;
  final int maxLength;

  StringProperty({
    Key? key,
    required this.label,
    this.hint,
    this.autofocus = false,
    required this.getProperty,
    this.setProperty,
    this.editable,
    this.validator,
    this.flex = 1,
    this.obscureText = false,
    this.maxLength = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: getProperty(),
      decoration: InputDecoration(
        //filled: true,
        hintText: hint,
        labelText: label,
      ),
      enabled: enabled,
      autofocus: autofocus,
      validator: validator,
      obscureText: obscureText,
      //maxLength: property.maxLength,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      // minLines: 1,
      // maxLines: 3,
      onSaved: setProperty,
    );
  }
}

//TODO: Potser seria millor que fos un stateful widget que implementés validable
//i que no fés el save fins que és vàlid, així evitaríem per exmple que es mostressin
//a l'informe valors incoherents. Es podria mirar el onchanged i fer que es validés el
//resultat cada cop que onchanged, i si el resultat és vàlid que es fes el save
//Ara tal com està actuant: qualsevol canvi que hi hagi al form provoca el setProperty
//a través del onSaved
//Això permetria que el Validable de DynamicForm tingués en compte el Validable dels de més avall
