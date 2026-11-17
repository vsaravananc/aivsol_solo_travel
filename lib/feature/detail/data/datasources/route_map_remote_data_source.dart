import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/extensions/dio_extension.dart';
import '../models/route_map_model.dart';

abstract class RouteMapRemoteDataSource {
  Future<Either<Failure, RouteMapModel>> getRouteMap({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  });
}

class RouteMapRemoteDataSourceImpl implements RouteMapRemoteDataSource {
  final Dio dio;

  RouteMapRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, RouteMapModel>> getRouteMap({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/$startLng,$startLat;$endLng,$endLat';

      final response = await dio.get(
        url,
        queryParameters: {'overview': 'full', 'geometries': 'geojson'},
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

      final code = data['code'];
      if (code == 'NoRoute') {
        return const Left(
          LocationNotFoundFailure(
            'No driving route found between coordinates.',
          ),
        );
      }

      if (code != 'Ok') {
        final message =
            data['message']?.toString() ?? 'Routing error occurred.';
        return Left(ServerFailure(message));
      }

      return Right(RouteMapModel.fromJson(data));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } on FormatException catch (e) {
      return Left(FormateFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
