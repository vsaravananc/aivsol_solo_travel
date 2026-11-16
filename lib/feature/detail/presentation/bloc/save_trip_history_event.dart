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

class RestartSaveTripHistoryEvent extends SaveTripHistoryEvent {
  const RestartSaveTripHistoryEvent();
}

class SaveTripHistoryRequested extends SaveTripHistoryEvent {
  final LocationEntity from;
  final LocationEntity to;
  final DateTime startDate;
  final DateTime endDate;
  final TravelStyle travelStyle;
  final BudgetEntity budget;
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
