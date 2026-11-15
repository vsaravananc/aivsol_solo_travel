import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/calculate_budget.dart';
import '../../domain/usecases/get_route_distance.dart';
import 'estimate_budget_event.dart';
import 'estimate_budget_state.dart';

class EstimateBudgetBloc
    extends Bloc<EstimateBudgetEvent, EstimateBudgetState> {
  final GetRouteDistance getRouteDistance;
  final CalculateBudget calculateBudget;

  EstimateBudgetBloc({
    required this.getRouteDistance,
    required this.calculateBudget,
  }) : super(const EstimateBudgetInitial()) {
    on<EstimateBudgetCalculationEvent>(_onEstimateBudgetCalculation);
  }

  Future<void> _onEstimateBudgetCalculation(
    EstimateBudgetCalculationEvent event,
    Emitter<EstimateBudgetState> emit,
  ) async {
    emit(const EstimateBudgetLoading());

    final result = await getRouteDistance.getRoundTripDistance(
      fromLatitude: event.fromLocation.latitude,
      fromLongitude: event.fromLocation.longitude,
      toLatitude: event.toLocation.latitude,
      toLongitude: event.toLocation.longitude,
    );

    result.fold((failure) => emit(EstimateBudgetFailure(failure.message)), (
      routeEntity,
    ) {
      final start = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );
      final end = DateTime(
        event.endDate.year,
        event.endDate.month,
        event.endDate.day,
      );
      final diffDays = end.difference(start).inDays;
      final tripDays = diffDays + 1;
      final hotelNights = diffDays;
      final roundTripKm = (routeEntity.rawdistance / 1000) * 2;

      final budget = calculateBudget.calculate(
        distanceInKm: roundTripKm,
        tripDays: tripDays,
        hotelNights: hotelNights,
        travelStyle: event.travelStyle,
      );
      emit(
        EstimateBudgetSuccess(
          budget: budget,
          cachedDistanceInKm: roundTripKm,
          tripDays: tripDays,
          hotelNights: hotelNights,
          currentStyle: event.travelStyle,
        ),
      );
    });
  }
}
