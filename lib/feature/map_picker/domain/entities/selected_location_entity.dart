import 'package:equatable/equatable.dart';

class SelectedLocationEntity extends Equatable {
  final String address;
  final double latitude;
  final double longitude;

  const SelectedLocationEntity({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [address, latitude, longitude];
}
