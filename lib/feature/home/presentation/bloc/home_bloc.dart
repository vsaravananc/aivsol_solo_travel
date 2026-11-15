import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(_initialState()) {
    on<FromLocationChangedEvent>(_onFromLocationChanged);
    on<ToLocationChangedEvent>(_onToLocationChanged);
    on<LocationsSwappedEvent>(_onLocationsSwapped);
    on<DateRangeChangedEvent>(_onDateRangeChanged);
    on<TravelStyleChangedEvent>(_onTravelStyleChanged);
    on<RevertSelectedEvent>(_onRevertSelected);
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    debugPrint('-' * 80);
    debugPrint(transition.toString().replaceAll(',', '\n'));
    debugPrint('-' * 80);
    super.onTransition(transition);
  }

  static HomeState _initialState() {
    final now = DateTime.now();
    return HomeState(
      startDate: DateTime(now.year, now.month, now.day + 1),
      endDate: DateTime(now.year, now.month, now.day + 5),
      travelStyle: TravelStyle.standard,
    );
  }

  void _onFromLocationChanged(
    FromLocationChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(from: event.from));
  }

  void _onToLocationChanged(
    ToLocationChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(to: event.to));
  }

  void _onLocationsSwapped(
    LocationsSwappedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      from: state.to,
      to: state.from,
    ));
  }

  void _onDateRangeChanged(
    DateRangeChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
  }

  void _onTravelStyleChanged(
    TravelStyleChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(travelStyle: event.travelStyle));
  }

  void _onRevertSelected(RevertSelectedEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(
      from: '',
      to: '',
    ));
  }
}
