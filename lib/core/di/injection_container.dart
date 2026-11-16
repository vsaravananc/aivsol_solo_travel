import 'package:aivsol_solo_travel/core/database/app_database.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../feature/detail/data/datasources/route_remote_data_source.dart';
import '../../feature/detail/data/local/trip_history_local_data_source.dart';
import '../../feature/detail/data/datasources/weather_remote_data_source.dart';
import '../../feature/detail/data/repositories/route_repository_impl.dart';
import '../../feature/detail/data/repositories/trip_history_repository_impl.dart';
import '../../feature/detail/data/repositories/weather_repository_impl.dart';
import '../../feature/detail/domain/repositories/route_repository.dart';
import '../../feature/detail/domain/repositories/trip_history_repository.dart';
import '../../feature/detail/domain/repositories/weather_repository.dart';
import '../../feature/detail/domain/usecases/calculate_budget.dart';
import '../../feature/detail/domain/usecases/get_route_distance.dart';
import '../../feature/detail/domain/usecases/get_weather_forecast.dart';
import '../../feature/detail/domain/usecases/get_trip_history_by_id.dart';
import '../../feature/detail/domain/usecases/save_trip_history.dart';
import '../../feature/detail/presentation/bloc/estimate_budget_bloc.dart';
import '../../feature/detail/presentation/bloc/save_trip_history_bloc.dart';
import '../../feature/detail/presentation/bloc/weather_bloc.dart';
import '../../feature/history/data/repositories/history_repository_impl.dart';
import '../../feature/history/domain/repositories/history_repository.dart';
import '../../feature/history/domain/usecases/get_all_trip_history.dart';
import '../../feature/history/presentation/bloc/history_bloc.dart';
import '../../feature/home/data/datasources/trip_geocoding_remote_data_source.dart';
import '../../feature/home/data/repositories/recent_trips_repository_impl.dart';
import '../../feature/home/data/repositories/trip_geocoding_repository_impl.dart';
import '../../feature/home/domain/repositories/recent_trips_repository.dart';
import '../../feature/home/domain/repositories/trip_geocoding_repository.dart';
import '../../feature/home/domain/usecases/get_location_coordinates.dart';
import '../../feature/home/domain/usecases/get_recent_trips.dart';
import '../../feature/home/domain/usecases/resolve_trip_locations.dart';
import '../../feature/home/presentation/bloc/home_bloc.dart';
import '../../feature/home/presentation/bloc/location_bloc.dart';
import '../../feature/home/presentation/bloc/recent_trips_bloc.dart';

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

  sl.registerLazySingleton<TripHistoryLocalDataSource>(
    () => TripHistoryLocalDataSource(),
  );

  sl.registerLazySingleton<TripHistoryRepository>(
    () => TripHistoryRepositoryImpl(
      localDataSource: sl<TripHistoryLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<SaveTripHistory>(
    () => SaveTripHistory(sl<TripHistoryRepository>()),
  );

  sl.registerLazySingleton<GetTripHistoryById>(
    () => GetTripHistoryById(sl<TripHistoryRepository>()),
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

  sl.registerLazySingleton<ResolveTripLocations>(
    () => const ResolveTripLocations(),
  );

  sl.registerFactory<HomeBloc>(() => HomeBloc());

  sl.registerFactory<LocationBloc>(
    () => LocationBloc(
      getLocationCoordinates: sl<GetLocationCoordinates>(),
      resolveTripLocations: sl<ResolveTripLocations>(),
    ),
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

  sl.registerFactory<SaveTripHistoryBloc>(
    () => SaveTripHistoryBloc(saveTripHistory: sl<SaveTripHistory>()),
  );

  sl.registerLazySingleton<RecentTripsRepository>(
    () => RecentTripsRepositoryImpl(
      localDataSource: sl<TripHistoryLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetRecentTrips>(
    () => GetRecentTrips(sl<RecentTripsRepository>()),
  );

  sl.registerFactory<RecentTripsBloc>(
    () => RecentTripsBloc(getRecentTrips: sl<GetRecentTrips>()),
  );

  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      localDataSource: sl<TripHistoryLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetAllTripHistory>(
    () => GetAllTripHistory(sl<HistoryRepository>()),
  );

  sl.registerFactory<HistoryBloc>(
    () => HistoryBloc(getAllTripHistory: sl<GetAllTripHistory>()),
  );

  await AppDatabase.testing();
}
