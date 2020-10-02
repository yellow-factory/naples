
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for Spanish Castilian (`es`).
class NaplesLocalizationsEs extends NaplesLocalizations {
  NaplesLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get required => 'El campo es obligatorio.';

  @override
  String get stringRequired => 'Introduce un texto.';

  @override
  String stringMaxLength(int max) {
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String maxString = maxNumberFormat.format(max);

    return 'El texto no puede tener más de ${maxString} carácteres.';
  }

  @override
  String stringMinLength(int min) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String minString = minNumberFormat.format(min);

    return 'El texto no puede tener menos de ${minString} carácteres.';
  }

  @override
  String stringRegularExpression(String expression) {
    return 'El texto no cumple con la expresión regular ${expression}';
  }

  @override
  String get numberRequired => 'Introduce un número diferente de cero.';
}
