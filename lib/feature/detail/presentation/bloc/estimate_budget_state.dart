import 'package:equatable/equatable.dart';

import '../../../../core/enums/travel_style.dart';
import '../../domain/entities/budget_entity.dart';

sealed class EstimateBudgetState extends Equatable {
  const EstimateBudgetState();

  @override
  List<Object?> get props => [];
}

class EstimateBudgetInitial extends EstimateBudgetState {
  const EstimateBudgetInitial();
}

class EstimateBudgetLoading extends EstimateBudgetState {
  const EstimateBudgetLoading();
}

class EstimateBudgetSuccess extends EstimateBudgetState {
  final BudgetEntity budget;
  final double cachedDistanceInKm;
  final int tripDays;
  final int hotelNights;
  final TravelStyle currentStyle;

  const EstimateBudgetSuccess({
    required this.budget,
    required this.cachedDistanceInKm,
    required this.tripDays,
    required this.hotelNights,
    required this.currentStyle,
  });

  @override
  List<Object?> get props => [
        budget,
        cachedDistanceInKm,
        tripDays,
        hotelNights,
        currentStyle,
      ];
}

class EstimateBudgetFailure extends EstimateBudgetState {
  final String errorMessage;

  const EstimateBudgetFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
