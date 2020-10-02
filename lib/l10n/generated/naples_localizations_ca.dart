
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Catalan Valencian (`ca`).
class NaplesLocalizationsCa extends NaplesLocalizations {
  NaplesLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get numberMax => 'Introdueix un nombre inferior a {max}.';

  @override
  String get numberMin => 'Introdueix un nombre major de {min}.';

  @override
  String get numberNegative => 'Introdueix un nombre negatiu.';

  @override
  String get numberPositive => 'Introdueix un nombre positiu.';

  @override
  String numberRange(Object min, Object max) {
    return 'Introdueix un nombre entre ${min} i ${max}.';
  }

  @override
  String get numberRequired => 'Introdueix un número diferent de zero.';

  @override
  String get required => 'El camp és obligatori.';

  @override
  String stringMaxLength(Object max) {
    return 'La llargada del text no pot ser major de ${max} caràcters.';
  }

  @override
  String stringMinLength(Object min) {
    return 'La llargada del text no pot ser menor de ${min} caràcters.';
  }

  @override
  String stringRegularExpression(Object expression) {
    return 'El text no segueix l\'expressió regular: \$expression';
  }

  @override
  String get stringRequired => 'Introdueix un text.';
}
