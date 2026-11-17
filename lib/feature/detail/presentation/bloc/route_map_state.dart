import 'package:equatable/equatable.dart';

import '../../domain/entities/route_map_entity.dart';

sealed class RouteMapState extends Equatable {
  const RouteMapState();

  @override
  List<Object?> get props => [];
}

class RouteMapInitial extends RouteMapState {
  const RouteMapInitial();
}

class RouteMapLoading extends RouteMapState {
  const RouteMapLoading();
}

class RouteMapLoaded extends RouteMapState {
  final RouteMapEntity route;

  const RouteMapLoaded({required this.route});

  @override
  List<Object?> get props => [route];
}

class RouteMapFailure extends RouteMapState {
  final String errorMessage;

  const RouteMapFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
