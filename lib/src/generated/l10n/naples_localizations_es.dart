// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class NaplesLocalizationsEs extends NaplesLocalizations {
  NaplesLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get continua => 'Siguiente';

  @override
  String get torna => 'Anterior';

  @override
  String get finalitza => 'Finaliza';

  @override
  String get newItem => 'Nuevo';

  @override
  String get accept => 'Aceptar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get clearSelection => 'Borrar selección';

  @override
  String get openForEditing => 'Abrir para editar';

  @override
  String get select => 'Buscar y seleccionar';

  @override
  String get filterBy => 'Filtra por';

  @override
  String confirmDeleteMessage(String itemName) {
    return '¿Estás seguro de que quieres eliminar $itemName?';
  }

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String errorLoadingItems(String error) {
    return 'Error cargando elementos: $error';
  }
}
