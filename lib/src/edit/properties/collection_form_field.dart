import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naples/src/edit/properties/collection_field.dart';
import 'package:navy/navy.dart';

class CollectionFormField<T> extends FormField<Iterable<T>> {
  CollectionFormField({
    super.key,
    required String name,
    FunctionOf1<int, Future<String>>? description,
    double width = 800,
    required FunctionOf1<T, String> itemTitle,
    FunctionOf1<T, String>? itemSubtitle,
    super.initialValue,
    required Future<T?> Function() createT,
    required FunctionOf1<T, T> updateT,
    required FunctionOf1<T, Widget>? createWidget,
    required FunctionOf1<T, Widget> updateWidget,
    super.onSaved,
    super.validator,
    PredicateOf0? editable,
    FunctionOf1<T, String>? itemDialogTitle,
    String? dialogSubtitle,
    double itemDialogContentWidth = 400,
  }) : super(
          builder: (FormFieldState<Iterable<T>> state) {
            return CollectionField<T>(
              createT: createT,
              createWidget: createWidget,
              itemTitle: itemTitle,
              itemSubtitle: itemSubtitle,
              name: name,
              initialValue: initialValue,
              updateT: updateT,
              updateWidget: updateWidget,
              description: description,
              width: width,
              onChanged: (t) => state.didChange(t),
              editable: editable,
              itemDialogTitle: itemDialogTitle,
              dialogSubtitle: dialogSubtitle,
              errorText: state.errorText,
              itemDialogContentWidth: itemDialogContentWidth,
            );
          },
        );
}
