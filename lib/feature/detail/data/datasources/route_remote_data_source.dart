import 'package:aivsol_solo_travel/core/error/failures.dart';
import 'package:aivsol_solo_travel/core/extensions/dio_extension.dart';
import 'package:aivsol_solo_travel/core/utility/api_end_points.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../models/route_model.dart';

abstract class RouteRemoteDataSource {
  Future<Either<Failure, RouteModel>> getRoundTripDistance({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  });
}

class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  final Dio dio;
  RouteRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, RouteModel>> getRoundTripDistance({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) async {
    try {
      final response = await dio.get(
        '${ApiEndPoints.osrm}/$fromLongitude,$fromLatitude;$toLongitude,$toLatitude',
        queryParameters: {'overview': 'false'},
      );

      if (response.statusCode != 200) {
        return const Left(
          ServerFailure('OSRM server error. Please try again later.'),
        );
      }

      final dynamic data = response.data;
      if (data == null || data is! Map<String, dynamic>) {
        return const Left(
          ParsingFailure('Unexpected routing API response structure.'),
        );
      }
      return Right(RouteModel.fromJson(data));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on FormatException {
      return const Left(FormateFailure('Failed to parse routing API response'));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
