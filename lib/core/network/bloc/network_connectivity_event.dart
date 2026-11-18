import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class NetworkConnectivityEvent extends Equatable {
  const NetworkConnectivityEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers network connectivity monitoring and initial check.
class NetworkConnectivityStarted extends NetworkConnectivityEvent {
  const NetworkConnectivityStarted();
}

/// Dispatched when the network interface changes (e.g. Wi-Fi, cellular, none).
class NetworkConnectivityChanged extends NetworkConnectivityEvent {
  final List<ConnectivityResult> results;

  const NetworkConnectivityChanged(this.results);

  @override
  List<Object?> get props => [results];
}
