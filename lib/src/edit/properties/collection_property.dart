import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/edit/properties/collection_form_field.dart';
import 'package:navy/navy.dart';

class CollectionProperty<T> extends StatelessWidget implements Expandable {
  final String name;
  final FunctionOf1<int, Future<String>>? description;
  final double width;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String>? itemSubtitle;
  final Future<T?> Function() create;
  final FunctionOf1<T, T> update;
  final FunctionOf1<T, Widget>? createWidget;
  final FunctionOf1<T, Widget> updateWidget;
  final Iterable<T>? initialValue;
  final FormFieldSetter<Iterable<T>>? onSaved;
  final PredicateOf0? editable;
  final FunctionOf1<T, String>? itemDialogTitle;
  final String? dialogSubtitle;
  final FormFieldValidator<Iterable<T>>? validator;
  final double itemDialogContentWidth;
  @override
  final int flex;

  const CollectionProperty({
    super.key,
    required this.name,
    this.description,
    this.width = 800,
    this.initialValue,
    required this.itemTitle,
    this.itemSubtitle,
    required this.create,
    required this.update,
    required this.createWidget,
    required this.updateWidget,
    this.onSaved,
    this.editable,
    this.itemDialogTitle,
    this.dialogSubtitle,
    this.validator,
    this.itemDialogContentWidth = 400,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CollectionFormField(
      name: name,
      description: description,
      itemTitle: itemTitle,
      itemSubtitle: itemSubtitle,
      initialValue: initialValue,
      createT: create,
      updateT: update,
      createWidget: createWidget,
      updateWidget: updateWidget,
      onSaved: onSaved,
      editable: editable,
      itemDialogTitle: itemDialogTitle,
      dialogSubtitle: dialogSubtitle,
      validator: validator,
      itemDialogContentWidth: itemDialogContentWidth,
    );
  }
}
