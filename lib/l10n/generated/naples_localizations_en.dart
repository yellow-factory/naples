
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for English (`en`).
class NaplesLocalizationsEn extends NaplesLocalizations {
  NaplesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get required => 'Please enter some text';

  @override
  String get stringRequired => 'Please enter some text';

  @override
  String stringMaxLength(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String maxString = maxNumberFormat.format(max);

    return 'Max length cannot be greater than ${maxString}';
  }

  @override
  String stringMinLength(int min) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String minString = minNumberFormat.format(min);

    return 'Minimum length cannot be lower than \$min';
  }

  @override
  String stringRegularExpression(String expression) {
    return 'Is not matching the regular expression: \$expression';
  }

  @override
  String get numberRequired => 'Please enter some number different than zero';
}
