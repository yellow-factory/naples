import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navy/navy.dart';
import '../collection_editor.dart';

class CollectionField<T> extends StatefulWidget {
  final String name;
  final FunctionOf0<Future<String>>? description;
  final double width;
  final Iterable<T>? initialValue;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf0<T> createT;
  final FunctionOf1<T, T> updateT;
  final FunctionOf1<T, Widget>? createWidget;
  final FunctionOf1<T, Widget> updateWidget;
  final ActionOf1<List<T>>? onChanged;
  final PredicateOf0? editable;

  const CollectionField({
    super.key,
    required this.name,
    this.description,
    this.width = 800,
    required this.itemTitle,
    this.initialValue,
    required this.createT,
    required this.updateT,
    required this.createWidget,
    required this.updateWidget,
    this.editable,
    this.onChanged,
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
      _descriptionController.text = await widget.description!();
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
            height: 500,
            child: CollectionEditor<T>(
              title: () => widget.name,
              items: _items,
              itemTitle: widget.itemTitle,
              editable: widget.editable,
              updateWidget: (itemToUpdate) {
                itemToEdit = itemToUpdate;
                itemEdited = widget.updateT(itemToUpdate);
                return Form(key: _formKey, child: widget.updateWidget(itemEdited as T));
              },
              update: () {
                if (itemEdited == null) {
                  throw Exception('The createItem cannot be null in this context');
                }
                if (_formKey.currentState == null) {
                  throw Exception('The form containing the createWidget does not exist');
                }
                var formState = _formKey.currentState!;
                if (!formState.validate()) return;
                formState.save();
                _items.remove(itemToEdit);
                _items.add(itemEdited as T);
                if (widget.onChanged != null) widget.onChanged!(_items);
              },
              createWidget: () {
                itemEdited = widget.createT();
                if (widget.createWidget == null) return const Placeholder();
                return Form(key: _formKey, child: widget.createWidget!(itemEdited as T));
              },
              create: () async {
                if (itemEdited == null) {
                  throw Exception('The createItem cannot be null in this context');
                }
                if (_formKey.currentState == null) {
                  throw Exception('The form containing the createWidget does not exist');
                }
                var formState = _formKey.currentState!;
                if (!formState.validate()) return;
                formState.save();

                _items.add(itemEdited as T);
                await _updateDescription();
                if (widget.onChanged != null) widget.onChanged!(_items);
              },
              delete: (itemToDelete) {
                _items.remove(itemToDelete);
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
    return TextFormField(
      controller: _descriptionController,
      readOnly: true,
      enabled: true,
      autofocus: false,
      decoration: InputDecoration(
        labelText: widget.name,
        suffixIcon: IconButton(onPressed: _showSelectDialog, icon: const Icon(Icons.edit_outlined)),
      ),
    );
  }
}
