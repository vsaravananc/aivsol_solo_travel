import 'package:equatable/equatable.dart';

class RouteEntity extends Equatable {
  final double rawdistance;

  const RouteEntity({required this.rawdistance});

  @override
  List<Object?> get props => [rawdistance];
}
