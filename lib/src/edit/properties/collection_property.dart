import 'dart:async';
import 'package:flutter/material.dart';
import 'package:navy/navy.dart';
import '../collection_editor.dart';

class CollectionProperty<T> extends StatefulWidget {
  final String name;
  final FunctionOf0<Future<String>>? description;
  final double width;
  final List<T> properties;
  final FunctionOf1<T, String> itemTitle;
  final FunctionOf0<T> createT;
  final FunctionOf1<T, T> updateT;
  final FunctionOf1<T, Widget>? createWidget;
  final FunctionOf1<T, Widget> updateWidget;

  const CollectionProperty({
    Key? key,
    required this.name,
    this.description,
    this.width = 800,
    required this.itemTitle,
    required this.properties,
    required this.createT,
    required this.updateT,
    required this.createWidget,
    required this.updateWidget,
  }) : super(key: key);

  @override
  State<CollectionProperty> createState() => _CollectionPropertyState<T>();
}

class _CollectionPropertyState<T> extends State<CollectionProperty<T>> {
  T? itemToEdit;
  T? itemEdited;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDescription();
  }

  Future<void> _updateDescription() async {
    if (widget.description != null) {
      _descriptionController.text = await widget.description!();
      return;
    }
    _descriptionController.text = "Collection of ${typeOf<T>()}(${widget.properties.length})";
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
              title: () => "Collection of ${widget.name}",
              items: widget.properties,
              itemTitle: widget.itemTitle,              
              updateWidget: (itemToUpdate) {
                itemToEdit = itemToUpdate;
                itemEdited = widget.updateT(itemToUpdate);
                return Form(
                  key: _formKey,
                  child: widget.updateWidget(itemEdited as T),
                );
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
                widget.properties.remove(itemToEdit);
                widget.properties.add(itemEdited as T);
              },
              createWidget: () {
                itemEdited = widget.createT();
                if (widget.createWidget == null) return const Placeholder();
                return Form(
                  key: _formKey,
                  child: widget.createWidget!(itemEdited as T),
                );
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

                widget.properties.add(itemEdited as T);
                await _updateDescription();
              },
              delete: (itemToDelete) {
                widget.properties.remove(itemToDelete);
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
        suffixIcon: IconButton(
          onPressed: _showSelectDialog,
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
