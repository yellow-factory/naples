import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navy/navy.dart';
import '../collection_editor.dart';

class CollectionField<T> extends StatefulWidget {
  final String name;
  final FunctionOf1<int, Future<String>>? description;
  final double width;
  final Iterable<T>? initialValue;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf1<T, String>? itemSubtitle;
  final Future<T?> Function() createT;
  final FunctionOf1<T, T> updateT;
  final FunctionOf1<T, Widget>? createWidget;
  final FunctionOf1<T, Widget> updateWidget;
  final ActionOf1<List<T>>? onChanged;
  final PredicateOf0? editable;
  final FunctionOf1<T, String>? itemDialogTitle;
  final String? dialogSubtitle;
  final String? errorText;
  final double itemDialogContentWidth;

  const CollectionField({
    super.key,
    required this.name,
    this.description,
    this.width = 800,
    required this.itemTitle,
    this.itemSubtitle,
    this.initialValue,
    required this.createT,
    required this.updateT,
    required this.createWidget,
    required this.updateWidget,
    this.editable,
    this.onChanged,
    this.itemDialogTitle,
    this.dialogSubtitle,
    this.errorText,
    this.itemDialogContentWidth = 400,
  });

  @override
  State<CollectionField> createState() => _CollectionFieldState<T>();
}

class _CollectionFieldState<T> extends State<CollectionField<T>> {
  late final List<T> _items;
  T? itemToEdit;
  T? itemEdited;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _items = widget.initialValue != null ? List<T>.from(widget.initialValue!) : <T>[];
    _updateDescription();
  }

  Future<void> _updateDescription() async {
    if (widget.description != null) {
      _descriptionController.text = await widget.description!(_items.length);
      return;
    }
    _descriptionController.text = "Items in the collection: ${_items.length}";
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showSelectDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 440,
            height: 520,
            child: CollectionEditor<T>(
              title: () => widget.name,
              subtitle: () => widget.dialogSubtitle ?? _descriptionController.text,
              items: _items,
              itemTitle: widget.itemTitle,
              itemSubtitle: widget.itemSubtitle,
              editable: widget.editable,
              itemDialogTitle: widget.itemDialogTitle,
              dialogContentWidth: widget.itemDialogContentWidth,
              updateWidget: (itemToUpdate) {
                itemToEdit = itemToUpdate;
                itemEdited = widget.updateT(itemToUpdate);
                return Form(key: _formKey, child: widget.updateWidget(itemEdited as T));
              },
              update: () {
                if (itemEdited == null) {
                  throw Exception('The editItem cannot be null in this context');
                }
                if (_formKey.currentState == null) return false;
                final formState = _formKey.currentState!;
                if (!formState.validate()) return false;
                formState.save();
                _items.remove(itemToEdit);
                _items.add(itemEdited as T);
                if (widget.onChanged != null) widget.onChanged!(_items);
                _updateDescription();
                return true;
              },
              createWidget: () async {
                final newItem = await widget.createT();
                if (newItem == null) return null;
                itemEdited = newItem;
                if (widget.createWidget == null) return null;
                final form = Form(key: _formKey, child: widget.createWidget!(itemEdited as T));
                final title = widget.itemDialogTitle?.call(itemEdited as T);
                return (widget: form, title: title);
              },
              create: () {
                if (itemEdited == null) {
                  throw Exception('The createItem cannot be null in this context');
                }
                if (_formKey.currentState == null) return false;
                final formState = _formKey.currentState!;
                if (!formState.validate()) return false;
                formState.save();
                _items.add(itemEdited as T);
                if (widget.onChanged != null) widget.onChanged!(_items);
                _updateDescription();
                return true;
              },
              delete: (itemToDelete) {
                _items.remove(itemToDelete);
                _updateDescription();
                if (widget.onChanged != null) widget.onChanged!(_items);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      readOnly: true,
      enabled: true,
      autofocus: false,
      decoration: InputDecoration(
        labelText: widget.name,
        errorText: widget.errorText,
        suffixIcon: IconButton(onPressed: _showSelectDialog, icon: const Icon(Icons.edit_outlined)),
      ),
    );
  }
}
