import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../feature/detail/data/datasources/route_remote_data_source.dart';
import '../../feature/detail/data/datasources/weather_remote_data_source.dart';
import '../../feature/detail/data/repositories/route_repository_impl.dart';
import '../../feature/detail/data/repositories/weather_repository_impl.dart';
import '../../feature/detail/domain/repositories/route_repository.dart';
import '../../feature/detail/domain/repositories/weather_repository.dart';
import '../../feature/detail/domain/usecases/calculate_budget.dart';
import '../../feature/detail/domain/usecases/get_route_distance.dart';
import '../../feature/detail/domain/usecases/get_weather_forecast.dart';
import '../../feature/detail/presentation/bloc/estimate_budget_bloc.dart';
import '../../feature/detail/presentation/bloc/weather_bloc.dart';
import '../../feature/home/data/datasources/trip_geocoding_remote_data_source.dart';
import '../../feature/home/data/local/trip_plan_local_data_source.dart';
import '../../feature/home/data/repositories/trip_geocoding_repository_impl.dart';
import '../../feature/home/domain/repositories/trip_geocoding_repository.dart';
import '../../feature/home/domain/usecases/get_location_coordinates.dart';
import '../../feature/home/presentation/bloc/home_bloc.dart';
import '../../feature/home/presentation/bloc/location_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {'Accept': 'application/json'},
      ),
    );
    return dio;
  });

  sl.registerLazySingleton<TripPlanLocalDataSource>(
    () => TripPlanLocalDataSource(),
  );

  sl.registerLazySingleton<TripGeocodingRemoteDataSource>(
    () => TripGeocodingRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<RouteRemoteDataSource>(
    () => RouteRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<TripGeocodingRepository>(
    () => TripGeocodingRepositoryImpl(
      remoteDataSource: sl<TripGeocodingRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<WeatherRepository>(
    () =>
        WeatherRepositoryImpl(remoteDataSource: sl<WeatherRemoteDataSource>()),
  );

  sl.registerLazySingleton<RouteRepository>(
    () => RouteRepositoryImpl(remoteDataSource: sl<RouteRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetLocationCoordinates>(
    () => GetLocationCoordinates(sl<TripGeocodingRepository>()),
  );

  sl.registerLazySingleton<GetWeatherForecast>(
    () => GetWeatherForecast(sl<WeatherRepository>()),
  );

  sl.registerLazySingleton<GetRouteDistance>(
    () => GetRouteDistance(sl<RouteRepository>()),
  );

  sl.registerLazySingleton<CalculateBudget>(() => const CalculateBudget());

  sl.registerFactory<HomeBloc>(() => HomeBloc());

  sl.registerFactory<LocationBloc>(
    () => LocationBloc(getLocationCoordinates: sl<GetLocationCoordinates>()),
  );

  sl.registerFactory<WeatherBloc>(
    () => WeatherBloc(getWeatherForecast: sl<GetWeatherForecast>()),
  );

  sl.registerFactory<EstimateBudgetBloc>(
    () => EstimateBudgetBloc(
      getRouteDistance: sl<GetRouteDistance>(),
      calculateBudget: sl<CalculateBudget>(),
    ),
  );
}
