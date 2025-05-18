import 'dart:async'; // Added for FutureOr

import 'package:flutter/material.dart';
import 'package:naples/dialogs.dart';
import 'package:navy/navy.dart';

class SelectDialogFormField<U, V> extends FormField<U> {
  SelectDialogFormField({
    super.key,
    required String label,
    String? hint,
    super.initialValue,
    super.enabled = true,
    super.onSaved,
    super.validator,
    required FunctionOf0<FutureOr<List<V>>> listItems, // Changed type here
    required FunctionOf1<V, U> valueMember,
    required FunctionOf1<V, FunctionOf0<String>> displayMember,
    Function(U?)? onChanged,
  }) : super(
         builder: (FormFieldState<U> state) {
           return _SelectDialogWidget<U, V>(
             state: state,
             label: label,
             hint: hint,
             enabled: enabled,
             listItems: listItems,
             valueMember: valueMember,
             displayMember: displayMember,
             onChanged: onChanged,
           );
         },
       );
}

class _SelectDialogWidget<U, V> extends StatefulWidget {
  final FormFieldState<U> state;
  final String label;
  final String? hint;
  final bool enabled;
  final FunctionOf0<FutureOr<List<V>>> listItems;
  final FunctionOf1<V, U> valueMember;
  final FunctionOf1<V, FunctionOf0<String>> displayMember;
  final Function(U?)? onChanged;

  const _SelectDialogWidget({
    required this.state,
    required this.label,
    this.hint,
    required this.enabled,
    required this.listItems,
    required this.valueMember,
    required this.displayMember,
    this.onChanged,
  });

  @override
  _SelectDialogWidgetState<U, V> createState() => _SelectDialogWidgetState<U, V>();
}

class _SelectDialogWidgetState<U, V> extends State<_SelectDialogWidget<U, V>> {
  final TextEditingController _controller = TextEditingController();
  List<V>? _cachedResolvedItems;
  bool _isDialogLoadingItems = false;

  @override
  void initState() {
    super.initState();
    final itemsOrFuture = widget.listItems();
    if (itemsOrFuture is List<V>) {
      _cachedResolvedItems = itemsOrFuture;
    }
    _updateTextController(widget.state.value);
  }

  @override
  void didUpdateWidget(covariant _SelectDialogWidget<U, V> oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool listItemsChanged = widget.listItems != oldWidget.listItems;
    if (listItemsChanged) {
      _cachedResolvedItems = null; // Invalidate cache
    }

    if (widget.state.value != oldWidget.state.value || listItemsChanged) {
      _updateTextController(widget.state.value);
    }
  }

  void _updateTextController(U? currentValue) {
    String newText;
    if (currentValue == null) {
      newText = "";
    } else {
      // Attempt to find the display text from cached items if available
      if (_cachedResolvedItems != null && _cachedResolvedItems!.isNotEmpty) {
        V? valueV;
        final matchingItems = _cachedResolvedItems!.where(
          (element) => widget.valueMember(element) == currentValue,
        );
        if (matchingItems.isNotEmpty) {
          valueV = matchingItems.first;
        }

        // If found in cache, use its display string. Otherwise, fallback to toString().
        newText = valueV == null ? currentValue.toString() : widget.displayMember(valueV)();
      } else {
        // If cache is not available or empty, just use toString().
        newText = currentValue.toString();
      }
    }

    if (_controller.text != newText) {
      _controller.text = newText;
    }
  }

  Future<void> _showSelectionDialog() async {
    if (_isDialogLoadingItems) return;

    if (_cachedResolvedItems == null) {
      setState(() {
        _isDialogLoadingItems = true;
      });
      try {
        final itemsOrFuture = widget.listItems();
        if (itemsOrFuture is Future<List<V>>) {
          _cachedResolvedItems = await itemsOrFuture;
        } else {
          _cachedResolvedItems = itemsOrFuture;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error loading items: $e")));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isDialogLoadingItems = false;
          });
        }
      }
    }

    if (!mounted || _cachedResolvedItems == null) return;

    V? currentSelectedV;
    if (widget.state.value != null && _cachedResolvedItems!.isNotEmpty) {
      final matchingItems = _cachedResolvedItems!.where(
        (element) => widget.valueMember(element) == widget.state.value,
      );
      if (matchingItems.isNotEmpty) {
        currentSelectedV = matchingItems.first;
      }
    }

    final result = await showSelectDialog<V>(
      title: widget.label,
      subtitle: widget.hint,
      context: context,
      items: _cachedResolvedItems!,
      selectedItem: currentSelectedV,
      displayMember: (t) => widget.displayMember(t)(),
    );

    if (result == null) return;

    var value = widget.valueMember(result);
    widget.state.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
    // Explicitly update the text controller with the new value
    // to ensure the TextField reflects the selection immediately.
    _updateTextController(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.state.errorText,
        suffixIcon:
            _isDialogLoadingItems
                ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                )
                : IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: widget.enabled ? _showSelectionDialog : null,
                ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
