import 'package:equatable/equatable.dart';

sealed class MapPickerEvent extends Equatable {
  const MapPickerEvent();

  @override
  List<Object?> get props => [];
}

class SearchPlacesEvent extends MapPickerEvent {
  final String query;

  const SearchPlacesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends MapPickerEvent {
  const ClearSearchEvent();
}

class ConfirmLocationEvent extends MapPickerEvent {
  final double latitude;
  final double longitude;

  const ConfirmLocationEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class ClearConfirmationErrorEvent extends MapPickerEvent {
  const ClearConfirmationErrorEvent();
}
