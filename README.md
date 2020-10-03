# Naples

A Flutter framework to help creating ViewModels of different kinds: to make lists, forms, stepped forms, etc. and to navigate between between them and comunicate with a backend.

## Depends on

[provider](https://pub.dev/packages/provider)

## Localization

To generate the files needed for Localization:

````
gen-l10n 
    --arb-dir=lib/l10n 
    --template-arb-file=intl_en.arb 
    --output-localization-file=naples_localizations.dart 
    --output-class=NaplesLocalizations 
    --no-synthetic-package 
    --output-dir=lib/l10n/generated
````

The file must be imported in the project that uses naples:

````
    ...
    import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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


