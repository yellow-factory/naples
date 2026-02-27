// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class NaplesLocalizationsCa extends NaplesLocalizations {
  NaplesLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get continua => 'Continua';

  @override
  String get torna => 'Torna';

  @override
  String get finalitza => 'Finalitza';

  @override
  String get accept => 'Accepta';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get delete => 'Elimina';

  @override
  String get close => 'Tanca';

  @override
  String get clearSelection => 'Esborrar selecció';

  @override
  String get openForEditing => 'Obrir per editar';

  @override
  String get select => 'Seleccionar';

  @override
  String get filterBy => 'Filtrar per';

  @override
  String confirmDeleteMessage(String itemName) => 'Estàs segur que vols eliminar $itemName?';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String errorLoadingItems(String error) => 'Error carregant elements: $error';
}
