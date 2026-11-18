import 'package:flutter/material.dart';

/// Defines the launch strategy for an [ExternalAppConfig].
enum ExternalAppLaunchMode {
  /// Launch using an `https://` URL only. The OS will open the native app
  /// via Universal Links / App Links if installed; otherwise opens in browser.
  httpsOnly,

  /// Attempt a custom URI scheme first; fall back to [fallbackWebUrl] if the
  /// scheme cannot be opened.
  schemeWithHttpsFallback,
}

/// Immutable configuration that fully describes a third-party application
/// integration. Add a new entry to [ExternalApps] to register a new app —
/// no changes to the launcher or share sheet are needed.
class ExternalAppConfig {
  /// Human-readable name shown in error messages.
  final String appName;

  /// Icon displayed in the share sheet row.
  final IconData icon;

  /// Short, user-visible title for the action sheet row.
  final String title;

  /// Supporting subtitle for the action sheet row.
  final String subtitle;

  /// How the launcher should attempt to open this app.
  final ExternalAppLaunchMode launchMode;

  /// The primary URL (or URI scheme) to attempt first.
  ///
  /// - For [ExternalAppLaunchMode.httpsOnly]: must be a valid `https://` URL.
  /// - For [ExternalAppLaunchMode.schemeWithHttpsFallback]: a custom scheme URI
  ///   such as `airbnb://...`.
  ///
  /// Supports the following placeholders:
  ///   - `{destination}` – URI-encoded destination city / location name.
  ///   - `{destinationSlug}` – destination with spaces replaced by `-`.
  ///   - `{checkin}` – formatted check-in date (YYYY-MM-DD).
  ///   - `{checkout}` – formatted check-out date (YYYY-MM-DD).
  final String primaryUrl;

  /// The `https://` website URL to open when the primary URL fails.
  /// Required when [launchMode] is [ExternalAppLaunchMode.schemeWithHttpsFallback].
  /// For [ExternalAppLaunchMode.httpsOnly] the [primaryUrl] itself is the
  /// fallback; this field is ignored.
  ///
  /// Supports the same placeholders as [primaryUrl].
  final String? fallbackWebUrl;

  const ExternalAppConfig({
    required this.appName,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.launchMode,
    required this.primaryUrl,
    this.fallbackWebUrl,
  }) : assert(
          launchMode == ExternalAppLaunchMode.httpsOnly ||
              fallbackWebUrl != null,
          'fallbackWebUrl is required when launchMode is schemeWithHttpsFallback',
        );

  /// Returns [primaryUrl] with all placeholders substituted and URI-encoded.
  String buildPrimaryUrl({
    required String destination,
    required String checkin,
    required String checkout,
  }) =>
      _applyPlaceholders(
        primaryUrl,
        destination: destination,
        checkin: checkin,
        checkout: checkout,
      );

  /// Returns [fallbackWebUrl] with all placeholders substituted. Returns `null`
  /// when this config uses [ExternalAppLaunchMode.httpsOnly].
  String? buildFallbackUrl({
    required String destination,
    required String checkin,
    required String checkout,
  }) {
    final template = fallbackWebUrl;
    if (template == null) return null;
    return _applyPlaceholders(
      template,
      destination: destination,
      checkin: checkin,
      checkout: checkout,
    );
  }

  static String _applyPlaceholders(
    String template, {
    required String destination,
    required String checkin,
    required String checkout,
  }) {
    final slug = destination.trim().replaceAll(RegExp(r'\s+'), '-');
    return template
        .replaceAll('{destination}', Uri.encodeComponent(destination))
        .replaceAll('{destinationSlug}', slug)
        .replaceAll('{checkin}', checkin)
        .replaceAll('{checkout}', checkout);
  }
}
