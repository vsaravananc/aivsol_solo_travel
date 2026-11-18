import 'package:aivsol_solo_travel/core/external_apps/external_app_config.dart';
import 'package:aivsol_solo_travel/core/external_apps/external_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExternalAppConfig.buildPrimaryUrl', () {
    const checkin = '2026-12-20';
    const checkout = '2026-12-25';

    test('OYO URL contains lowercased slug without spaces', () {
      final url = ExternalApps.oyo.buildPrimaryUrl(
        destination: 'Bengaluru',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, contains('hotels-in-Bengaluru'));
      expect(url, startsWith('https://www.oyorooms.com'));
    });

    test('OYO URL slugifies multi-word destinations', () {
      final url = ExternalApps.oyo.buildPrimaryUrl(
        destination: 'New Delhi',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, contains('hotels-in-New-Delhi'));
    });

    test('Airbnb URL contains encoded destination and checkin/checkout dates', () {
      final url = ExternalApps.airbnb.buildPrimaryUrl(
        destination: 'Goa India',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, contains('Goa%20India'));
      expect(url, contains('checkin=2026-12-20'));
      expect(url, contains('checkout=2026-12-25'));
      expect(url, startsWith('https://www.airbnb.com'));
    });

    test('Airbnb URL encodes special characters in destination', () {
      final url = ExternalApps.airbnb.buildPrimaryUrl(
        destination: 'Coorg & Mysore',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, contains('Coorg%20%26%20Mysore'));
    });

    test('MakeMyTrip hotels URL contains encoded destination', () {
      final url = ExternalApps.makeMyTripHotels.buildPrimaryUrl(
        destination: 'Mumbai',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, contains('Mumbai'));
      expect(url, startsWith('https://www.makemytrip.com/hotels'));
    });

    test('MakeMyTrip flights URL is the flights landing page (no dynamic params)', () {
      final url = ExternalApps.makeMyTripFlights.buildPrimaryUrl(
        destination: 'Delhi',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, equals('https://www.makemytrip.com/flights/'));
    });

    test('IndiGo URL is the official homepage (no dynamic params)', () {
      final url = ExternalApps.indigo.buildPrimaryUrl(
        destination: 'Chennai',
        checkin: checkin,
        checkout: checkout,
      );
      expect(url, equals('https://www.goindigo.in'));
    });

    test('all external apps use https primary URLs', () {
      for (final config in ExternalApps.all) {
        expect(
          config.primaryUrl,
          startsWith('https://'),
          reason: '${config.appName} primaryUrl must start with https://',
        );
      }
    });

    test('ExternalApps.all contains exactly the expected apps', () {
      expect(ExternalApps.all.length, 5);
      final names = ExternalApps.all.map((c) => c.appName).toList();
      expect(names, containsAll(['OYO', 'Airbnb', 'MakeMyTrip', 'IndiGo']));
    });
  });

  group('ExternalAppConfig.buildFallbackUrl', () {
    test('httpsOnly config returns null for fallback', () {
      expect(
        ExternalApps.oyo.buildFallbackUrl(
          destination: 'Pune',
          checkin: '2026-01-01',
          checkout: '2026-01-05',
        ),
        isNull,
      );
    });

    test('schemeWithHttpsFallback config returns a substituted fallback URL', () {
      const config = ExternalAppConfig(
        appName: 'TestApp',
        icon: Icons.star,
        title: 'Test',
        subtitle: '',
        launchMode: ExternalAppLaunchMode.schemeWithHttpsFallback,
        primaryUrl: 'testapp://search?q={destination}',
        fallbackWebUrl: 'https://testapp.com/search?q={destination}',
      );
      final fallback = config.buildFallbackUrl(
        destination: 'Pune',
        checkin: '2026-01-01',
        checkout: '2026-01-05',
      );
      expect(fallback, 'https://testapp.com/search?q=Pune');
    });
  });

  group('ExternalAppConfig placeholder substitution', () {
    test('{destinationSlug} replaces spaces with hyphens', () {
      const config = ExternalAppConfig(
        appName: 'Test',
        icon: Icons.star,
        title: 'Test',
        subtitle: '',
        launchMode: ExternalAppLaunchMode.httpsOnly,
        primaryUrl: 'https://example.com/{destinationSlug}',
      );
      final url = config.buildPrimaryUrl(
        destination: 'New Delhi',
        checkin: '2026-01-01',
        checkout: '2026-01-05',
      );
      expect(url, 'https://example.com/New-Delhi');
    });

    test('{destination} percent-encodes the value', () {
      const config = ExternalAppConfig(
        appName: 'Test',
        icon: Icons.star,
        title: 'Test',
        subtitle: '',
        launchMode: ExternalAppLaunchMode.httpsOnly,
        primaryUrl: 'https://example.com/?q={destination}',
      );
      final url = config.buildPrimaryUrl(
        destination: 'Leh & Ladakh',
        checkin: '2026-01-01',
        checkout: '2026-01-05',
      );
      expect(url, 'https://example.com/?q=Leh%20%26%20Ladakh');
    });

    test('{checkin} and {checkout} are substituted verbatim', () {
      const config = ExternalAppConfig(
        appName: 'Test',
        icon: Icons.star,
        title: 'Test',
        subtitle: '',
        launchMode: ExternalAppLaunchMode.httpsOnly,
        primaryUrl: 'https://example.com/?in={checkin}&out={checkout}',
      );
      final url = config.buildPrimaryUrl(
        destination: 'Ooty',
        checkin: '2026-06-01',
        checkout: '2026-06-05',
      );
      expect(url, 'https://example.com/?in=2026-06-01&out=2026-06-05');
    });
  });
}
