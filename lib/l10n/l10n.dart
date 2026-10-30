import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

/// Convenience accessor: `context.l10n.someKey`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Loads the [AppLocalizations] instance without a [BuildContext].
///
/// Used by code that runs outside the widget tree (notification scheduling,
/// startup). The app currently ships only the `ru` template, so it is the
/// default; pass a [locale] to use a different one once translations exist.
Future<AppLocalizations> loadL10n([Locale? locale]) =>
    AppLocalizations.delegate.load(locale ?? const Locale('ru'));
