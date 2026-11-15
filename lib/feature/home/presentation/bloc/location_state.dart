import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';
import 'package:equatable/equatable.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationSuccess extends LocationState {
  final LocationEntity fromLocation;
  final LocationEntity toLocation;

  const LocationSuccess({
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  List<Object?> get props => [fromLocation, toLocation];
}

class LocationFailure extends LocationState {
  final String errorMessage;

  const LocationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
