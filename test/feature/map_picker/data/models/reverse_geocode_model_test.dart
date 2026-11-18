import 'package:aivsol_solo_travel/feature/map_picker/data/models/reverse_geocode_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReverseGeocodeModel Tests', () {
    test('successfully parses Nominatim reverse geocode JSON', () {
      final json = {
        'place_id': 98765,
        'display_name': 'Central Railway Station, Chennai, Tamil Nadu, 600003, India',
        'lat': '13.0827',
        'lon': '80.2707',
      };

      final model = ReverseGeocodeModel.fromJson(
        json,
        fallbackLatitude: 13.0827,
        fallbackLongitude: 80.2707,
      );

      expect(
        model.address,
        'Central Railway Station, Chennai, Tamil Nadu, 600003, India',
      );
      expect(model.latitude, 13.0827);
      expect(model.longitude, 80.2707);
    });

    test('throws FormatException if display_name is missing or empty', () {
      final json = {
        'error': 'Unable to geocode',
      };

      expect(
        () => ReverseGeocodeModel.fromJson(
          json,
          fallbackLatitude: 13.0827,
          fallbackLongitude: 80.2707,
        ),
        throwsFormatException,
      );
    });
  });
}
