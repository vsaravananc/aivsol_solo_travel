import 'package:url_launcher/url_launcher.dart';
import 'external_app_config.dart';

/// Describes the outcome of an [ExternalAppLauncher.launch] call.
enum LaunchOutcome {
  /// The primary URL (app or website) was opened successfully.
  primaryOpened,

  /// The primary URL failed but the HTTPS fallback was opened successfully.
  fallbackOpened,

  /// Both the primary URL and fallback failed.
  failed,
}

/// Result returned by [ExternalAppLauncher.launch].
class LaunchResult {
  final LaunchOutcome outcome;

  /// Non-null when [outcome] is [LaunchOutcome.failed].
  final String? errorMessage;

  const LaunchResult._(this.outcome, {this.errorMessage});

  factory LaunchResult.primaryOpened() =>
      const LaunchResult._(LaunchOutcome.primaryOpened);

  factory LaunchResult.fallbackOpened() =>
      const LaunchResult._(LaunchOutcome.fallbackOpened);

  factory LaunchResult.failed([String? message]) =>
      LaunchResult._(LaunchOutcome.failed, errorMessage: message);

  bool get didOpen =>
      outcome == LaunchOutcome.primaryOpened ||
      outcome == LaunchOutcome.fallbackOpened;
}

/// Stateless, platform-agnostic service that launches third-party applications
/// from an [ExternalAppConfig].
///
/// Fallback strategy:
///   1. Build the primary URL.
///   2. For [ExternalAppLaunchMode.httpsOnly]: attempt `launchUrl` directly.
///   3. For [ExternalAppLaunchMode.schemeWithHttpsFallback]: attempt the scheme
///      URI first; on failure attempt the HTTPS fallback URL.
///   4. If all attempts fail, return [LaunchResult.failed].
///
/// The caller is responsible for showing any user-facing error UI.
abstract final class ExternalAppLauncher {
  /// Launches the app described by [config] using [params] for URL substitution.
  ///
  /// Never throws; all exceptions are caught and surfaced via [LaunchResult].
  static Future<LaunchResult> launch({
    required ExternalAppConfig config,
    required String destination,
    required String checkin,
    required String checkout,
  }) async {
    final primaryUrlStr = config.buildPrimaryUrl(
      destination: destination,
      checkin: checkin,
      checkout: checkout,
    );

    switch (config.launchMode) {
      case ExternalAppLaunchMode.httpsOnly:
        return _tryLaunch(primaryUrlStr);

      case ExternalAppLaunchMode.schemeWithHttpsFallback:
        final primaryResult = await _tryLaunch(primaryUrlStr);
        if (primaryResult.didOpen) return primaryResult;

        final fallbackStr = config.buildFallbackUrl(
          destination: destination,
          checkin: checkin,
          checkout: checkout,
        );
        if (fallbackStr == null) {
          return LaunchResult.failed(
            'Unable to open ${config.appName}. Please try again.',
          );
        }

        final fallbackResult = await _tryLaunch(fallbackStr);
        if (fallbackResult.didOpen) return LaunchResult.fallbackOpened();
        return LaunchResult.failed(
          'Unable to open ${config.appName}. Please try again.',
        );
    }
  }

  static Future<LaunchResult> _tryLaunch(String urlStr) async {
    final Uri? uri = Uri.tryParse(urlStr);
    if (uri == null) return LaunchResult.failed('Invalid URL.');

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      return launched ? LaunchResult.primaryOpened() : LaunchResult.failed();
    } catch (_) {
      return LaunchResult.failed();
    }
  }
}
