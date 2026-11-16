import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_weather_forecast.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherForecast getWeatherForecast;

  WeatherBloc({required this.getWeatherForecast})
    : super(const WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<LoadLocalWeatherEvent>(_onLoadLocalWeather);
  }

  void _onLoadLocalWeather(
    LoadLocalWeatherEvent event,
    Emitter<WeatherState> emit,
  ) {
    if (event.weather != null) {
      emit(
        WeatherSuccess(
          weather: event.weather!,
          totalTripDays: event.totalTripDays,
        ),
      );
    } else {
      emit(const WeatherFailure('No weather data saved for this trip.'));
    }
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());
    final result = await getWeatherForecast.getWeatherForecast(
      latitude: event.destinationLocation.latitude,
      longitude: event.destinationLocation.longitude,
      fromDate: event.startDate,
      toDate: event.endDate,
    );

    result.fold(
      (failure) => emit(WeatherFailure(failure.message)),
      (weather) => emit(
        WeatherSuccess(
          weather: weather,
          totalTripDays: event.endDate.difference(event.startDate).inDays + 1,
        ),
      ),
    );
  }
}
