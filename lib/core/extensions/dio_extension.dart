import 'package:dio/dio.dart';

import '../error/failures.dart';

extension DioExceptionExtension on DioException {
  Failure toFailure() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ConnectionFailure(
          'Unable to connect. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        return const ServerFailure(
          'Routing server error. Please try again later.',
        );
      case DioExceptionType.cancel:
        return const ServerFailure('Route calculation request was cancelled.');
      default:
        return const ConnectionFailure(
          'Unexpected error while calculating route.',
        );
    }
  }
}
