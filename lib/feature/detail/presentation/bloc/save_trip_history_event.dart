import 'package:equatable/equatable.dart';

import '../../../../core/enums/travel_style.dart';
import '../../../home/domain/entities/location_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/weather_entity.dart';

sealed class SaveTripHistoryEvent extends Equatable {
  const SaveTripHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered once both budget and weather data are available on the detail
/// screen. Carries all the data needed to persist a complete trip record.
class SaveTripHistoryRequested extends SaveTripHistoryEvent {
  final LocationEntity from;
  final LocationEntity to;
  final DateTime startDate;
  final DateTime endDate;
  final TravelStyle travelStyle;
  final BudgetEntity budget;

  /// Weather is optional — the trip is saved even if weather fetch failed.
  final WeatherEntity? weather;

  const SaveTripHistoryRequested({
    required this.from,
    required this.to,
    required this.startDate,
    required this.endDate,
    required this.travelStyle,
    required this.budget,
    this.weather,
  });

  @override
  List<Object?> get props => [
        from,
        to,
        startDate,
        endDate,
        travelStyle,
        budget,
        weather,
      ];
}
