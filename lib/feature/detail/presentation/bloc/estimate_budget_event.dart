import 'package:equatable/equatable.dart';

import '../../../../core/enums/travel_style.dart';
import '../../../home/domain/entities/location_entity.dart';
import '../../domain/entities/budget_entity.dart';

sealed class EstimateBudgetEvent extends Equatable {
  const EstimateBudgetEvent();

  @override
  List<Object?> get props => [];
}

class EstimateBudgetCalculationEvent extends EstimateBudgetEvent {
  final LocationEntity fromLocation;
  final LocationEntity toLocation;
  final DateTime startDate;
  final DateTime endDate;
  final TravelStyle travelStyle;

  const EstimateBudgetCalculationEvent({
    required this.fromLocation,
    required this.toLocation,
    required this.startDate,
    required this.endDate,
    required this.travelStyle,
  });

  @override
  List<Object?> get props => [
        fromLocation,
        toLocation,
        startDate,
        endDate,
        travelStyle,
      ];
}

class LoadLocalBudgetEvent extends EstimateBudgetEvent {
  final BudgetEntity budget;
  final TravelStyle travelStyle;

  const LoadLocalBudgetEvent({
    required this.budget,
    required this.travelStyle,
  });

  @override
  List<Object?> get props => [budget, travelStyle];
}
