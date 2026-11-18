import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(_initialState()) {
    on<FromLocationSelectedEvent>(_onFromLocationSelected);
    on<ToLocationSelectedEvent>(_onToLocationSelected);
    on<FromLocationChangedEvent>(_onFromLocationChanged);
    on<ToLocationChangedEvent>(_onToLocationChanged);
    on<LocationsSwappedEvent>(_onLocationsSwapped);
    on<DateRangeChangedEvent>(_onDateRangeChanged);
    on<TravelStyleChangedEvent>(_onTravelStyleChanged);
    on<RevertSelectedEvent>(_onRevertSelected);
  }

  static HomeState _initialState() {
    final now = DateTime.now();
    return HomeState(
      startDate: DateTime(now.year, now.month, now.day + 1),
      endDate: DateTime(now.year, now.month, now.day + 5),
      travelStyle: TravelStyle.standard,
    );
  }

  void _onFromLocationSelected(
    FromLocationSelectedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      from: event.address,
      fromLatitude: event.latitude,
      fromLongitude: event.longitude,
    ));
  }

  void _onToLocationSelected(
    ToLocationSelectedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      to: event.address,
      toLatitude: event.latitude,
      toLongitude: event.longitude,
    ));
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
      fromLatitude: state.toLatitude,
      fromLongitude: state.toLongitude,
      to: state.from,
      toLatitude: state.fromLatitude,
      toLongitude: state.fromLongitude,
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
      clearFrom: true,
      clearTo: true,
    ));
  }
}
