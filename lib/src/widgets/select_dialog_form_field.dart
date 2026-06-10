import 'dart:async'; // Added for FutureOr

import 'package:flutter/material.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/dialogs/selector_dialog.dart';
import 'package:naples/src/generated/l10n/naples_localizations.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:naples/src/widgets/field_scaffold.dart';
import 'package:navy/navy.dart';

class SelectDialogFormField<U, V> extends FormField<U> {
  SelectDialogFormField({
    super.key,
    required String label,
    String? hint,
    String? help,
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
    String? Function(U?)? labelForValue,
  }) : super(
         builder: (FormFieldState<U> state) {
           return _SelectDialogWidget<U, V>(
             state: state,
             label: label,
             hint: hint,
             help: help,
             enabled: enabled,
             listItems: listItems,
             valueMember: valueMember,
             displayMember: displayMember,
             onChanged: onChanged,
             onNavigate: onNavigate,
             clearable: clearable,
             labelForValue: labelForValue,
           );
         },
       );
}

class _SelectDialogWidget<U, V> extends StatefulWidget {
  final FormFieldState<U> state;
  final String label;
  final String? hint;
  final String? help;
  final bool enabled;
  final FunctionOf0<FutureOr<List<V>>> listItems;
  final FunctionOf1<V, U> valueMember;
  final FunctionOf1<V, FunctionOf0<String>> displayMember;
  final Function(U?)? onChanged;
  final FutureOr<void> Function(V)? onNavigate;
  final bool clearable;

  /// Resolves a display label directly from the current value, without needing
  /// the (often lazily-loaded) item list. Lets the collapsed control show a
  /// human-readable label on first render instead of the raw value/uid.
  final String? Function(U?)? labelForValue;

  const _SelectDialogWidget({
    required this.state,
    required this.label,
    this.hint,
    this.help,
    required this.enabled,
    required this.listItems,
    required this.valueMember,
    required this.displayMember,
    this.onChanged,
    this.onNavigate,
    this.clearable = false,
    this.labelForValue,
  });

  @override
  _SelectDialogWidgetState<U, V> createState() => _SelectDialogWidgetState<U, V>();
}

class _SelectDialogWidgetState<U, V> extends State<_SelectDialogWidget<U, V>> {
  NaplesLocalizations get _l =>
      NaplesLocalizations.of(context) ??
      (throw Exception("NaplesLocalizations not found in the context"));

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
  }

  @override
  void didUpdateWidget(covariant _SelectDialogWidget<U, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listItems != oldWidget.listItems) {
      _cachedResolvedItems = null; // Invalidate cache
    }
  }

  /// The text shown for the current value, resolved from cached items when
  /// available, falling back to `toString()`.
  String _displayText() {
    final currentValue = widget.state.value;
    if (currentValue == null) return '';
    // Prefer a label resolved straight from the value (e.g. a reference's
    // description, or an enum-id → name lookup) so the first render isn't a
    // raw uid/id while the item list is still loading.
    final fromValue = widget.labelForValue?.call(currentValue);
    if (fromValue != null && fromValue.isNotEmpty) return fromValue;
    if (_cachedResolvedItems != null && _cachedResolvedItems!.isNotEmpty) {
      final matching = _cachedResolvedItems!.where(
        (element) => widget.valueMember(element) == currentValue,
      );
      if (matching.isNotEmpty) return widget.displayMember(matching.first)();
    }
    return currentValue.toString();
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
        setState(() {});
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
      setState(() {});
    }
  }

  void _clearValue() {
    widget.state.didChange(null);
    widget.onChanged?.call(null);
    setState(() {});
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
    final t = NaplesFieldTokens.of(context);
    final roLook = !widget.enabled;
    final hasNavigateAction = widget.onNavigate != null && widget.state.value != null;
    final text = _displayText();
    final empty = text.isEmpty;

    Widget action(IconData icon, VoidCallback onTap, String tooltip) =>
        FieldActionButton(icon: icon, onPressed: onTap, tooltip: tooltip);

    const spinner = Padding(
      padding: EdgeInsets.all(6.0),
      child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.0)),
    );

    final trailing = <Widget>[];
    if (_isDialogLoadingItems) {
      trailing.add(spinner);
    } else if (widget.enabled) {
      if (hasNavigateAction) {
        trailing.add(_isNavigating
            ? spinner
            : action(Icons.open_in_new, _handleNavigate, _l.openForEditing));
      }
      trailing.add(action(Icons.search, _showSelectionDialog, _l.select));
      if (widget.clearable && widget.state.value != null) {
        trailing.add(action(Icons.close, _clearValue, _l.clearSelection));
      }
    }

    return FieldScaffold(
      label: widget.label,
      readOnly: roLook,
      help: widget.help,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          FieldBox(
            readOnly: roLook,
            padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
            minHeight: FieldBox.singleLineHeight,
            center: true,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    empty ? (widget.hint ?? '—') : text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: empty ? FontWeight.w400 : FontWeight.w600,
                      color: empty ? t.muted : t.text,
                    ),
                  ),
                ),
                ...trailing,
              ],
            ),
          ),
          if (widget.state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.state.errorText ?? '',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}
