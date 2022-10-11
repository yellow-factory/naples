import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';
import 'package:clipboard/clipboard.dart';

class StringProperty extends StatelessWidget with ModelProperty<String?>, Expandable {
  @override
  final int flex;
  @override
  final String label;
  @override
  final String? hint;
  @override
  final bool autofocus;
  @override
  final PredicateOf0? editable;
  @override
  final FunctionOf0<String?> getProperty;
  @override
  final ActionOf1<String?>? setProperty;
  @override
  final FunctionOf1<String?, String?>? validator;
  final bool obscureText;
  final int maxLength;
  final bool showCopyButton;
  final bool readOnly;

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
    this.showCopyButton = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: getProperty(),
      decoration: InputDecoration(
        //filled: true,
        hintText: hint,
        labelText: label,
        suffixIcon: showCopyButton
            ? IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  FlutterClipboard.copy(getProperty() ?? '');
                },
              )
            : null,
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
      readOnly: readOnly,
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
