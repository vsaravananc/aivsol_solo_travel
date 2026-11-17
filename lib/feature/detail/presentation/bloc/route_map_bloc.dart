import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_route_map_usecase.dart';
import 'route_map_event.dart';
import 'route_map_state.dart';

class RouteMapBloc extends Bloc<RouteMapEvent, RouteMapState> {
  final GetRouteMapUseCase getRouteMapUseCase;
  FetchRouteMapEvent? _lastEvent;

  RouteMapBloc({required this.getRouteMapUseCase})
      : super(const RouteMapInitial()) {
    on<FetchRouteMapEvent>(_onFetchRouteMap);
  }

  bool _isValidCoordinate(double lat, double lng) {
    if (!lat.isFinite || !lng.isFinite || lat.isNaN || lng.isNaN) return false;
    if (lat < -90.0 || lat > 90.0) return false;
    if (lng < -180.0 || lng > 180.0) return false;
    if (lat == 0.0 && lng == 0.0) return false;
    return true;
  }

  Future<void> _onFetchRouteMap(
    FetchRouteMapEvent event,
    Emitter<RouteMapState> emit,
  ) async {
    if (state is RouteMapLoaded && _lastEvent == event) {
      return;
    }
    if (state is RouteMapLoading && _lastEvent == event) {
      return;
    }

    _lastEvent = event;

    if (!_isValidCoordinate(event.startLat, event.startLng) ||
        !_isValidCoordinate(event.endLat, event.endLng)) {
      emit(const RouteMapFailure('Invalid or missing coordinates.'));
      return;
    }

    emit(const RouteMapLoading());

    final result = await getRouteMapUseCase(
      startLat: event.startLat,
      startLng: event.startLng,
      endLat: event.endLat,
      endLng: event.endLng,
    );

    result.fold(
      (failure) => emit(RouteMapFailure(failure.message)),
      (route) {
        if (route.coordinates.isEmpty) {
          emit(const RouteMapFailure('Empty route coordinates received.'));
        } else {
          emit(RouteMapLoaded(route: route));
        }
      },
    );
  }
}

