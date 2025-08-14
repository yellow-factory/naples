import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'naples_localizations_ca.dart';
import 'naples_localizations_en.dart';
import 'naples_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of NaplesLocalizations
/// returned by `NaplesLocalizations.of(context)`.
///
/// Applications need to include `NaplesLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/naples_localizations.dart';
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
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
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
  NaplesLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static NaplesLocalizations? of(BuildContext context) {
    return Localizations.of<NaplesLocalizations>(context, NaplesLocalizations);
  }

  static const LocalizationsDelegate<NaplesLocalizations> delegate =
      _NaplesLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// To go to the next step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get continua;

  /// To go to the previous step
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get torna;

  /// To end the sequence of steps
  ///
  /// In en, this message translates to:
  /// **'Finalize'**
  String get finalitza;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
}

class _NaplesLocalizationsDelegate
    extends LocalizationsDelegate<NaplesLocalizations> {
  const _NaplesLocalizationsDelegate();

  @override
  Future<NaplesLocalizations> load(Locale locale) {
    return SynchronousFuture<NaplesLocalizations>(
      lookupNaplesLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_NaplesLocalizationsDelegate old) => false;
}

NaplesLocalizations lookupNaplesLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return NaplesLocalizationsCa();
    case 'en':
      return NaplesLocalizationsEn();
    case 'es':
      return NaplesLocalizationsEs();
  }

  throw FlutterError(
    'NaplesLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
