import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naples/src/edit/properties/collection_field.dart';
import 'package:navy/navy.dart';

class CollectionFormField<T> extends FormField<Iterable<T>> {
  CollectionFormField({
    super.key,
    required String name,
    FunctionOf0<Future<String>>? description,
    double width = 800,
    required FunctionOf1<T, String> itemTitle,
    super.initialValue,
    required FunctionOf0<T> createT,
    required FunctionOf1<T, T> updateT,
    required FunctionOf1<T, Widget>? createWidget,
    required FunctionOf1<T, Widget> updateWidget,
    super.onSaved,
    PredicateOf0? editable,
  }) : super(
          builder: (FormFieldState<Iterable<T>> state) {
            return CollectionField<T>(
              createT: createT,
              createWidget: createWidget,
              itemTitle: itemTitle,
              name: name,
              initialValue: initialValue,
              updateT: updateT,
              updateWidget: updateWidget,
              description: description,
              width: width,
              onChanged: (t) => state.didChange(t),
              editable: editable,
            );
          },
        );
}
