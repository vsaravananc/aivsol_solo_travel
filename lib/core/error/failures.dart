import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred. Please try again later.']);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'No internet connection. Please check your network and try again.']);
}

class LocationNotFoundFailure extends Failure {
  const LocationNotFoundFailure([super.message = 'Location not found. Please verify the city name.']);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Invalid data received. Please try again.']);
}

class FormateFailure extends Failure {
  const FormateFailure([super.message = 'Invalid data received. Please try again.']);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error occurred.']);
}
