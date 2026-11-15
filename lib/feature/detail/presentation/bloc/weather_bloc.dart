import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_weather_forecast.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherForecast getWeatherForecast;

  WeatherBloc({required this.getWeatherForecast})
    : super(const WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
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
