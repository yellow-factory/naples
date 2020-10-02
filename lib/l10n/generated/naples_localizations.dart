
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'naples_localizations_ca.dart';
import 'naples_localizations_en.dart';
import 'naples_localizations_es.dart';

/// Callers can lookup localized strings with an instance of NaplesLocalizations returned
/// by `NaplesLocalizations.of(context)`.
///
/// Applications need to include `NaplesLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'generated/naples_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: NaplesLocalizations.localizationsDelegates,
///   supportedLocales: NaplesLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: 0.16.1
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the NaplesLocalizations.supportedLocales
/// property.
abstract class NaplesLocalizations {
  NaplesLocalizations(String locale) : assert(locale != null), localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static NaplesLocalizations of(BuildContext context) {
    return Localizations.of<NaplesLocalizations>(context, NaplesLocalizations);
  }

  static const LocalizationsDelegate<NaplesLocalizations> delegate = _NaplesLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es')
  ];

  // The conventional newborn programmer greeting
  String get helloNaples;
}

class _NaplesLocalizationsDelegate extends LocalizationsDelegate<NaplesLocalizations> {
  const _NaplesLocalizationsDelegate();

  @override
  Future<NaplesLocalizations> load(Locale locale) {
    return SynchronousFuture<NaplesLocalizations>(_lookupNaplesLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_NaplesLocalizationsDelegate old) => false;
}

NaplesLocalizations _lookupNaplesLocalizations(Locale locale) {
  
  
  
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca': return NaplesLocalizationsCa();
    case 'en': return NaplesLocalizationsEn();
    case 'es': return NaplesLocalizationsEs();
  }

  assert(false, 'NaplesLocalizations.delegate failed to load unsupported locale "$locale"');
  return null;
}
