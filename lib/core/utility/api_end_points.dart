abstract final class ApiEndPoints {
  static const String _google = 'https://www.google.com';
  static const String map = '$_google/maps/search/?api=1&query=';
  static const String flight = '$_google/travel/flights';
  static const String hotel = '$_google/travel/hotels';

  static const String osrm = 'https://router.project-osrm.org/route/v1/driving';
  static const String openMeteoGeoCoding =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String openMeteoForecast =
      'https://api.open-meteo.com/v1/forecast';
}
