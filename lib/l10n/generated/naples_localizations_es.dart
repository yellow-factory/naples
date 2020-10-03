
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Spanish Castilian (`es`).
class NaplesLocalizationsEs extends NaplesLocalizations {
  NaplesLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get numberMax => 'Introduce un número inferior a {max}';

  @override
  String get numberMin => 'Introduce un número superior a {min}.';

  @override
  String get numberNegative => 'Introduce un número negativo.';

  @override
  String get numberPositive => 'Introduce un número positivo.';

  @override
  String numberRange(Object min, Object max) {
    return 'Introduce un número entre ${min} i ${max}.';
  }

  @override
  String get numberRequired => 'Introduce un número diferente de cero.';

  @override
  String get required => 'El campo es obligatorio.';

  @override
  String stringMaxLength(Object max) {
    return 'El texto no puede tener más de ${max} carácteres.';
  }

  @override
  String stringMinLength(Object min) {
    return 'El texto no puede tener menos de ${min} carácteres.';
  }

  @override
  String stringRegularExpression(Object expression) {
    return 'El texto no cumple con la expresión regular ${expression}.';
  }

  @override
  String get stringRequired => 'Introduce un texto.';
}
