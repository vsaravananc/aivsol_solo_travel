import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/reverse_geocode_usecase.dart';
import '../../domain/usecases/search_places_usecase.dart';
import 'map_picker_event.dart';
import 'map_picker_state.dart';

class MapPickerBloc extends Bloc<MapPickerEvent, MapPickerState> {
  final SearchPlacesUseCase searchPlacesUseCase;
  final ReverseGeocodeUseCase reverseGeocodeUseCase;

  CancelToken? _searchCancelToken;

  MapPickerBloc({
    required this.searchPlacesUseCase,
    required this.reverseGeocodeUseCase,
  }) : super(const MapPickerState()) {
    on<SearchPlacesEvent>(_onSearchPlaces);
    on<ClearSearchEvent>(_onClearSearch);
    on<ConfirmLocationEvent>(_onConfirmLocation);
    on<ClearConfirmationErrorEvent>(_onClearConfirmationError);
  }

  Future<void> _onSearchPlaces(
    SearchPlacesEvent event,
    Emitter<MapPickerState> emit,
  ) async {
    final query = event.query.trim();
    if (query.length < 2) {
      _searchCancelToken?.cancel();
      emit(state.copyWith(
        isSearching: false,
        searchResults: const [],
        clearSearchError: true,
      ));
      return;
    }

    _searchCancelToken?.cancel();
    _searchCancelToken = CancelToken();

    emit(state.copyWith(
      isSearching: true,
      clearSearchError: true,
    ));

    final result = await searchPlacesUseCase(
      query,
      cancelToken: _searchCancelToken,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isSearching: false,
          searchError: failure.message,
          searchResults: const [],
        ));
      },
      (places) {
        emit(state.copyWith(
          isSearching: false,
          searchResults: places,
          clearSearchError: true,
        ));
      },
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<MapPickerState> emit,
  ) {
    _searchCancelToken?.cancel();
    emit(state.copyWith(
      isSearching: false,
      searchResults: const [],
      clearSearchError: true,
    ));
  }

  Future<void> _onConfirmLocation(
    ConfirmLocationEvent event,
    Emitter<MapPickerState> emit,
  ) async {
    // Prevent multiple simultaneous confirmation requests
    if (state.isConfirming) return;

    emit(state.copyWith(
      isConfirming: true,
      clearConfirmationError: true,
      clearConfirmedLocation: true,
    ));

    final result = await reverseGeocodeUseCase(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isConfirming: false,
          confirmationError: failure.message,
        ));
      },
      (selectedLocation) {
        emit(state.copyWith(
          isConfirming: false,
          confirmedLocation: selectedLocation,
          clearConfirmationError: true,
        ));
      },
    );
  }

  void _onClearConfirmationError(
    ClearConfirmationErrorEvent event,
    Emitter<MapPickerState> emit,
  ) {
    emit(state.copyWith(clearConfirmationError: true));
  }

  @override
  Future<void> close() {
    _searchCancelToken?.cancel();
    return super.close();
  }
}
