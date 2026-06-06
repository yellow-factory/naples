import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/widgets/date_picker_utils.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:naples/src/widgets/field_scaffold.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    super.key,
    required String label,
    String? hint,
    String? help,
    bool filled = false,
    super.initialValue,
    bool autofocus = false,
    bool enabled = true,
    super.onSaved,
    super.validator,
    DateTime? firstDate,
    DateTime? lastDate,
    bool Function(DateTime)? selectableDayPredicate,
    required DateFormat dateFormat,
    bool onlyDate = true,
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           return _DateTimeFormFieldContent(
             state: state,
             label: label,
             hint: hint,
             help: help,
             filled: filled,
             autofocus: autofocus,
             enabled: enabled,
             firstDate: firstDate,
             lastDate: lastDate,
             selectableDayPredicate: selectableDayPredicate,
             dateFormat: dateFormat,
             onlyDate: onlyDate,
           );
         },
       );
}

class _DateTimeFormFieldContent extends StatefulWidget {
  final FormFieldState<DateTime> state;
  final String label;
  final String? hint;
  final String? help;
  final bool filled;
  final bool autofocus;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool Function(DateTime)? selectableDayPredicate;
  final DateFormat dateFormat;
  final bool onlyDate;

  const _DateTimeFormFieldContent({
    required this.state,
    required this.label,
    this.hint,
    this.help,
    required this.filled,
    required this.autofocus,
    required this.enabled,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate,
    required this.dateFormat,
    required this.onlyDate,
  });

  @override
  State<_DateTimeFormFieldContent> createState() => _DateTimeFormFieldContentState();
}

class _DateTimeFormFieldContentState extends State<_DateTimeFormFieldContent> {
  late TextEditingController _controller;
  DateTime? _lastValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _lastValue = widget.state.value;
    _syncText();
  }

  @override
  void didUpdateWidget(_DateTimeFormFieldContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_lastValue != widget.state.value) {
      _lastValue = widget.state.value;
      _syncText();
    }
  }

  void _syncText() {
    final value = widget.state.value;
    _controller.text = value != null ? widget.dateFormat.format(value.toLocal()) : '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentValue = widget.state.value?.toLocal() ?? DateTime.now();
    var currentFirstDate = widget.firstDate ?? DateTime(1900);
    var currentLastDate = widget.lastDate ?? DateTime(2100);
    // Flutter's showDatePicker asserts that the supplied initialDate is in
    // range AND satisfies selectableDayPredicate. Pick a safe seed so we
    // never trip that assertion when the current value is filtered out.
    final pickerInitial = safeInitialDate(
      preferred: currentValue,
      first: currentFirstDate,
      last: currentLastDate,
      predicate: widget.selectableDayPredicate,
    );

    Future<void> pick() async {
      final DateTime datePicked =
          await showDatePicker(
            context: context,
            initialDate: pickerInitial,
            firstDate: currentFirstDate,
            lastDate: currentLastDate,
            selectableDayPredicate: widget.selectableDayPredicate,
            fieldLabelText: widget.label,
            fieldHintText: widget.hint,
          ) ??
          currentValue;

      if (widget.onlyDate) {
        if (currentValue.compareTo(datePicked) != 0) {
          widget.state.didChange(datePicked);
        }
        return;
      }

      final TimeOfDay time = TimeOfDay.fromDateTime(currentValue);
      final TimeOfDay timePicked = mounted
          ? await showTimePicker(
                  context: mounted ? context : throw Exception('Not mounted'),
                  initialTime: time,
                  initialEntryMode: TimePickerEntryMode.input,
                ) ??
                time
          : time;

      if (!mounted) return;

      widget.state.didChange(
        DateTime(
          datePicked.year,
          datePicked.month,
          datePicked.day,
          timePicked.hour,
          timePicked.minute,
        ),
      );
    }

    final t = NaplesFieldTokens.of(context);
    final roLook = !widget.enabled;
    final value = _controller.text;
    final empty = value.isEmpty;

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
                    empty ? (widget.hint ?? '') : value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: empty ? t.muted : t.text),
                  ),
                ),
                if (widget.enabled)
                  FieldActionButton(icon: Icons.calendar_today_outlined, onPressed: pick),
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
