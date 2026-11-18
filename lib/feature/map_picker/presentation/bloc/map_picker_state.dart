import 'package:equatable/equatable.dart';

import '../../domain/entities/place_search_entity.dart';
import '../../domain/entities/selected_location_entity.dart';

class MapPickerState extends Equatable {
  final bool isSearching;
  final List<PlaceSearchEntity> searchResults;
  final String? searchError;
  final bool isConfirming;
  final String? confirmationError;
  final SelectedLocationEntity? confirmedLocation;

  const MapPickerState({
    this.isSearching = false,
    this.searchResults = const [],
    this.searchError,
    this.isConfirming = false,
    this.confirmationError,
    this.confirmedLocation,
  });

  MapPickerState copyWith({
    bool? isSearching,
    List<PlaceSearchEntity>? searchResults,
    String? searchError,
    bool clearSearchError = false,
    bool? isConfirming,
    String? confirmationError,
    bool clearConfirmationError = false,
    SelectedLocationEntity? confirmedLocation,
    bool clearConfirmedLocation = false,
  }) {
    return MapPickerState(
      isSearching: isSearching ?? this.isSearching,
      searchResults: searchResults ?? this.searchResults,
      searchError: clearSearchError ? null : (searchError ?? this.searchError),
      isConfirming: isConfirming ?? this.isConfirming,
      confirmationError: clearConfirmationError
          ? null
          : (confirmationError ?? this.confirmationError),
      confirmedLocation: clearConfirmedLocation
          ? null
          : (confirmedLocation ?? this.confirmedLocation),
    );
  }

  @override
  List<Object?> get props => [
        isSearching,
        searchResults,
        searchError,
        isConfirming,
        confirmationError,
        confirmedLocation,
      ];
}
