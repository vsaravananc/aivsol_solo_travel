import 'package:aivsol_solo_travel/feature/map_picker/data/models/place_search_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlaceSearchModel Tests', () {
    test('successfully parses Nominatim JSON item with city in displayName', () {
      final json = {
        'place_id': 12345,
        'name': 'Chennai',
        'display_name': 'Chennai, Tamil Nadu, India',
        'lat': '13.0827',
        'lon': '80.2707',
      };

      final model = PlaceSearchModel.fromJson(json);

      expect(model.name, 'Chennai');
      expect(model.displayName, 'Chennai');
      expect(model.latitude, 13.0827);
      expect(model.longitude, 80.2707);
    });

    test('parses city from address details when available', () {
      final json = {
        'place_id': 12345,
        'name': 'Marina Beach',
        'display_name':
            'Marina Beach, Kamarajar Salai, Triplicane, Chennai, Tamil Nadu, 600005, India',
        'lat': '13.0500',
        'lon': '80.2824',
        'address': {
          'beach': 'Marina Beach',
          'road': 'Kamarajar Salai',
          'suburb': 'Triplicane',
          'city': 'Chennai',
          'state': 'Tamil Nadu',
          'country': 'India',
        },
      };

      final model = PlaceSearchModel.fromJson(json);

      expect(model.name, 'Marina Beach');
      expect(model.displayName, 'Chennai');
      expect(model.latitude, 13.05);
      expect(model.longitude, 80.2824);
    });

    test('falls back to town/village from address details', () {
      final json = {
        'place_id': 54321,
        'name': 'Botanical Garden',
        'display_name': 'Botanical Garden, Ooty, The Nilgiris, Tamil Nadu, India',
        'lat': '11.4102',
        'lon': '76.6950',
        'address': {
          'tourism': 'attraction',
          'town': 'Ooty',
          'county': 'The Nilgiris',
          'state': 'Tamil Nadu',
        },
      };

      final model = PlaceSearchModel.fromJson(json);

      expect(model.name, 'Botanical Garden');
      expect(model.displayName, 'Ooty');
      expect(model.latitude, 11.4102);
      expect(model.longitude, 76.6950);
    });

    test('falls back to city component of display_name when name is empty', () {
      final json = {
        'name': '',
        'display_name': 'Marina Beach, Chennai, Tamil Nadu, India',
        'lat': '13.0500',
        'lon': '80.2824',
      };

      final model = PlaceSearchModel.fromJson(json);

      expect(model.name, 'Marina Beach');
      expect(model.displayName, 'Chennai');
      expect(model.latitude, 13.05);
      expect(model.longitude, 80.2824);
    });

    test('handles single-word display_name gracefully', () {
      final json = {
        'name': 'Bengaluru',
        'display_name': 'Bengaluru',
        'lat': '12.9716',
        'lon': '77.5946',
      };

      final model = PlaceSearchModel.fromJson(json);

      expect(model.name, 'Bengaluru');
      expect(model.displayName, 'Bengaluru');
      expect(model.latitude, 12.9716);
      expect(model.longitude, 77.5946);
    });
  });
}
