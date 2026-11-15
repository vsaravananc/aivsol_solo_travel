class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error occurred.']);

  @override
  String toString() => 'ServerException: $message';
}

class LocationNotFoundException implements Exception {
  final String message;
  const LocationNotFoundException([this.message = 'Location not found.']);

  @override
  String toString() => 'LocationNotFoundException: $message';
}

class ParsingException implements Exception {
  final String message;
  const ParsingException([this.message = 'Error parsing data.']);

  @override
  String toString() => 'ParsingException: $message';
}
