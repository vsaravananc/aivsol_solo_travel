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
    on<LoadLocalBudgetEvent>(_onLoadLocalBudget);
  }

  @override
  void onTransition(
    Transition<EstimateBudgetEvent, EstimateBudgetState> transition,
  ) {
    print('*' * 50);
    print(transition.toString().replaceAll(',', '\n'));
    print('*' * 50);
    super.onTransition(transition);
  }

  void _onLoadLocalBudget(
    LoadLocalBudgetEvent event,
    Emitter<EstimateBudgetState> emit,
  ) {
    emit(
      EstimateBudgetSuccess(
        budget: event.budget,
        cachedDistanceInKm: event.budget.distanceInKm,
        tripDays: event.budget.tripDays,
        hotelNights: event.budget.hotelNights,
        currentStyle: event.travelStyle,
      ),
    );
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
      final budget = calculateBudget.calculate(
        rawDistance: routeEntity.rawdistance,
        startDate: event.startDate,
        endDate: event.endDate,
        travelStyle: event.travelStyle,
      );
      emit(
        EstimateBudgetSuccess(
          budget: budget,
          cachedDistanceInKm: budget.distanceInKm,
          tripDays: budget.tripDays,
          hotelNights: budget.hotelNights,
          currentStyle: event.travelStyle,
        ),
      );
    });
  }
}
