
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Catalan Valencian (`ca`).
class NaplesLocalizationsCa extends NaplesLocalizations {
  NaplesLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get required => 'El camp és obligatori.';

  @override
  String get stringRequired => 'Introdueix un text.';

  @override
  String stringMaxLength(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String maxString = maxNumberFormat.format(max);

    return 'La llargada del text no pot ser major de ${maxString} caràcters.';
  }

  @override
  String stringMinLength(int min) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String minString = minNumberFormat.format(min);

    return 'La llargada del text no pot ser menor de ${minString} caràcters.';
  }

  @override
  String stringRegularExpression(String expression) {
    return 'El text no segueix l\'expressió regular: \$expression';
  }

  @override
  String get numberRequired => 'Introdueix un número diferent de zero.';
}
