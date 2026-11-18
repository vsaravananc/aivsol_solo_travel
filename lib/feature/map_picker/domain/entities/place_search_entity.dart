import 'package:equatable/equatable.dart';

class PlaceSearchEntity extends Equatable {
  final String name;
  final String displayName;
  final double latitude;
  final double longitude;

  const PlaceSearchEntity({
    required this.name,
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [name, displayName, latitude, longitude];
}
