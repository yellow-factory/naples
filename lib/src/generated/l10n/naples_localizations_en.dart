// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'naples_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class NaplesLocalizationsEn extends NaplesLocalizations {
  NaplesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get continua => 'Next';

  @override
  String get torna => 'Previous';

  @override
  String get finalitza => 'Finalize';

  @override
  String get accept => 'Accept';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get openForEditing => 'Open for editing';

  @override
  String get select => 'Select';

  @override
  String get filterBy => 'Filter by';

  @override
  String confirmDeleteMessage(String itemName) => 'Are you sure you want to delete the $itemName?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String errorLoadingItems(String error) => 'Error loading items: $error';
}
