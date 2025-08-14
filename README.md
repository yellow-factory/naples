# Naples

A Flutter framework to help creating ViewModels of different kinds: to make lists, forms, stepped forms, etc. and to navigate between between them and comunicate with a backend.

## Depends on

[provider](https://pub.dev/packages/provider)

## Localization

Naples provides built-in support for localization using the Flutter localization system. To add localization to your Naples application, follow these steps:

1. Create a directory for your localization files (e.g., `lib/l10n`).
2. Create ARB files for each language you want to support (e.g., `intl_en.arb`, `intl_es.arb`, etc.).
3. Add your localized strings to the ARB files.
4. Generate the file l10n.yaml and specify the tool options.
5. Run the `flutter gen-l10n` command to generate the necessary localization files or activate the synthetic package support modifying the `pubspec.yaml` file: with `flutter: generate: true ` as said in the https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization


The file must be imported in the project that uses naples:

````
    ...
    import 'package:naples/l10n/generated/naples_localizations.dart';

    ...
    return MaterialApp(
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates, //Localization file of the App
        NaplesLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales, //Localization file of the App
    );
    ...
    
````


