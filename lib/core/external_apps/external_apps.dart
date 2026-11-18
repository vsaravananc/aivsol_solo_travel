import 'package:flutter/material.dart';
import 'external_app_config.dart';

/// Central registry of supported third-party travel applications.
///
/// ## Adding a new application
/// 1. Add a new `static const ExternalAppConfig` field here with correct
///    [ExternalAppLaunchMode] and URL templates.
/// 2. Register the new config in the [all] list.
/// 3. Add a new `ShareOption` enum case that sets `externalApp` to the config.
/// 4. For iOS custom schemes, add the scheme to `LSApplicationQueriesSchemes`
///    in `ios/Runner/Info.plist`.
/// 5. For Android custom schemes, add an `<intent>` query to `<queries>` in
///    `android/app/src/main/AndroidManifest.xml`.
/// No changes to the launcher or share-sheet widget are needed.
abstract final class ExternalApps {
  /// ### OYO
  /// OYO does not publicly expose a custom URI scheme for external use.
  /// The website uses HTTPS path-based URLs with the city slug embedded in the
  /// path: `https://www.oyorooms.com/hotels-in-{city}/`.
  /// On both Android and iOS, if the OYO app is installed, the OS intercepts
  /// these `oyorooms.com` HTTPS URLs via App Links / Universal Links and opens
  /// the native app automatically. No `LSApplicationQueriesSchemes` or
  /// `<queries>` declaration is needed for HTTPS Universal Links.
  static const ExternalAppConfig oyo = ExternalAppConfig(
    appName: 'OYO',
    icon: Icons.bed_outlined,
    title: 'Book on OYO',
    subtitle: 'Find budget-friendly stays',
    launchMode: ExternalAppLaunchMode.httpsOnly,
    // City name is lowercased and slugified by _applyPlaceholders (destinationSlug).
    primaryUrl: 'https://www.oyorooms.com/hotels-in-{destinationSlug}/',
  );

  /// ### MakeMyTrip
  /// MakeMyTrip exposes the `mmyt://` custom scheme internally, but the scheme
  /// pattern and supported paths are not publicly documented for external use.
  /// We therefore use their official HTTPS website with best-effort query params:
  ///  - Hotels: `/hotels/hotel-listing/?searchText={destination}&checkin=...`
  ///  - Flights: `/flight/search` (SPA; no stable query-param contract)
  /// Because MakeMyTrip's flight SPA does not support constructible pre-filled
  /// URLs, we link directly to their homepage and let the user perform a search.
  static const ExternalAppConfig makeMyTripHotels = ExternalAppConfig(
    appName: 'MakeMyTrip',
    icon: Icons.hotel_rounded,
    title: 'Hotels on MakeMyTrip',
    subtitle: 'Compare hotel deals',
    launchMode: ExternalAppLaunchMode.httpsOnly,
    primaryUrl:
        'https://www.makemytrip.com/hotels/hotel-listing/?searchText={destination}',
  );

  static const ExternalAppConfig makeMyTripFlights = ExternalAppConfig(
    appName: 'MakeMyTrip',
    icon: Icons.flight_rounded,
    title: 'Flights on MakeMyTrip',
    subtitle: 'Book domestic & international flights',
    launchMode: ExternalAppLaunchMode.httpsOnly,
    // MakeMyTrip's flight search is SPA-driven; no public stable query params.
    // We open the flights landing page so the user can fill in the search form.
    primaryUrl: 'https://www.makemytrip.com/flights/',
  );

  /// ### IndiGo
  /// IndiGo (goindigo.in) does not expose a public custom URI scheme and its
  /// web flight search is SPA-driven with no stable constructible URL parameters.
  /// We open the official website so the user can search directly.
  static const ExternalAppConfig indigo = ExternalAppConfig(
    appName: 'IndiGo',
    icon: Icons.airplanemode_active_outlined,
    title: 'Fly with IndiGo',
    subtitle: 'Book IndiGo flights',
    launchMode: ExternalAppLaunchMode.httpsOnly,
    primaryUrl: 'https://www.goindigo.in',
  );

  /// ### Airbnb
  /// Airbnb supports:
  ///  - Custom scheme `airbnb://` (iOS & Android, internal; listed in some
  ///    APKs/IPAs). No stable external deep-link contract is published.
  ///  - HTTPS Universal Links / App Links with well-documented search params:
  ///    `checkin`, `checkout`, `query` (YYYY-MM-DD).
  /// We use HTTPS App Links with query params so the web always works as
  /// the natural fallback; no extra platform config is required.
  static const ExternalAppConfig airbnb = ExternalAppConfig(
    appName: 'Airbnb',
    icon: Icons.house_outlined,
    title: 'Stay on Airbnb',
    subtitle: 'Find unique homes & experiences',
    launchMode: ExternalAppLaunchMode.httpsOnly,
    primaryUrl:
        'https://www.airbnb.com/s/{destination}/homes?query={destination}&checkin={checkin}&checkout={checkout}&adults=1',
  );

  /// Complete list of all registered external application configs, in the order
  /// they should appear in the share sheet.
  static const List<ExternalAppConfig> all = [
    oyo,
    airbnb,
    makeMyTripHotels,
    makeMyTripFlights,
    indigo,
  ];
}
