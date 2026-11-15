import 'package:aivsol_solo_travel/feature/home/domain/usecases/get_location_coordinates.dart';
import 'package:aivsol_solo_travel/feature/home/domain/usecases/resolve_trip_locations.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/location_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocationCoordinates getLocationCoordinates;
  final ResolveTripLocations resolveTripLocations;

  LocationBloc({
    required this.getLocationCoordinates,
    required this.resolveTripLocations,
  }) : super(const LocationInitial()) {
    on<ResolveTripLocationsEvent>(_onResolveTripLocations);
    on<ResetLocationsEvent>(_onResetLocations);
  }

  Future<void> _onResolveTripLocations(
    ResolveTripLocationsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    final results = await Future.wait([
      getLocationCoordinates.getLocationCoordinates(event.fromCity),
      getLocationCoordinates.getLocationCoordinates(event.toCity),
    ]);

    final resolution = resolveTripLocations.resolveResults(results);

    resolution.fold(
      (failure) => emit(LocationFailure(failure.message)),
      (locations) => emit(
        LocationSuccess(
          fromLocation: locations.fromLocation,
          toLocation: locations.toLocation,
        ),
      ),
    );
  }

  void _onResetLocations(
    ResetLocationsEvent event,
    Emitter<LocationState> emit,
  ) {
    emit(const LocationInitial());
  }
}
