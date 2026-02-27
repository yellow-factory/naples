import 'dart:async'; // Added for FutureOr

import 'package:flutter/material.dart';
import 'package:naples/src/dialogs/selector_dialog.dart';
import 'package:naples/src/generated/l10n/naples_localizations.dart';
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
    FutureOr<void> Function(V)? onNavigate,
    bool clearable = false,
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
             onNavigate: onNavigate,
             clearable: clearable,
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
  final FutureOr<void> Function(V)? onNavigate;
  final bool clearable;

  const _SelectDialogWidget({
    required this.state,
    required this.label,
    this.hint,
    required this.enabled,
    required this.listItems,
    required this.valueMember,
    required this.displayMember,
    this.onChanged,
    this.onNavigate,
    this.clearable = false,
  });

  @override
  _SelectDialogWidgetState<U, V> createState() => _SelectDialogWidgetState<U, V>();
}

class _SelectDialogWidgetState<U, V> extends State<_SelectDialogWidget<U, V>> {
  NaplesLocalizations get _l =>
      NaplesLocalizations.of(context) ??
      (throw Exception("NaplesLocalizations not found in the context"));

  final TextEditingController _controller = TextEditingController();
  List<V>? _cachedResolvedItems;
  bool _isDialogLoadingItems = false;
  bool _isNavigating = false;

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

    if (widget.state.value != oldWidget.state.value || listItemsChanged) {
      // Update text controller BEFORE invalidating cache so the display
      // member lookup still works with the existing cached items.
      _updateTextController(widget.state.value);
    }

    if (listItemsChanged) {
      _cachedResolvedItems = null; // Invalidate cache
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
          ).showSnackBar(SnackBar(content: Text(_l.errorLoadingItems(e.toString()))));
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

    if (widget.clearable) {
      final result = await showSelectDialogClearable<V>(
        title: widget.label,
        subtitle: widget.hint,
        context: context,
        items: _cachedResolvedItems!,
        selectedItem: currentSelectedV,
        displayMember: (t) => widget.displayMember(t)(),
      );

      if (!mounted) return;

      if (result.cleared) {
        _clearValue();
      } else if (result.value != null) {
        final value = widget.valueMember(result.value as V);
        widget.state.didChange(value);
        widget.onChanged?.call(value);
        _updateTextController(value);
      }
    } else {
      final result = await showSelectDialog<V>(
        title: widget.label,
        subtitle: widget.hint,
        context: context,
        items: _cachedResolvedItems!,
        selectedItem: currentSelectedV,
        displayMember: (t) => widget.displayMember(t)(),
      );

      if (result == null) return;

      final value = widget.valueMember(result);
      widget.state.didChange(value);
      widget.onChanged?.call(value);
      // Explicitly update the text controller with the new value
      // to ensure the TextField reflects the selection immediately.
      _updateTextController(value);
    }
  }

  void _clearValue() {
    widget.state.didChange(null);
    widget.onChanged?.call(null);
    _updateTextController(null);
  }

  Future<void> _handleNavigate() async {
    if (widget.onNavigate == null || widget.state.value == null) return;
    if (_isNavigating) return;

    setState(() => _isNavigating = true);
    try {
      // Find the V item corresponding to the current value
      if (_cachedResolvedItems == null) {
        final itemsOrFuture = widget.listItems();
        if (itemsOrFuture is Future<List<V>>) {
          _cachedResolvedItems = await itemsOrFuture;
        } else {
          _cachedResolvedItems = itemsOrFuture;
        }
      }

      if (_cachedResolvedItems == null) return;

      final matchingItems = _cachedResolvedItems!.where(
        (element) => widget.valueMember(element) == widget.state.value,
      );

      if (matchingItems.isNotEmpty) {
        await widget.onNavigate!(matchingItems.first);
      }
    } finally {
      if (mounted) setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNavigateAction = widget.onNavigate != null && widget.state.value != null;

    return TextField(
      controller: _controller,
      readOnly: true,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.state.errorText,
        suffixIcon: _isDialogLoadingItems
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              )
            : widget.enabled
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasNavigateAction)
                    _isNavigating
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2.0),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.open_in_new),
                            onPressed: _handleNavigate,
                            tooltip: _l.openForEditing,
                          ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: _showSelectionDialog,
                    tooltip: _l.select,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
