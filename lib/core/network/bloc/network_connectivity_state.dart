import 'package:equatable/equatable.dart';

abstract class NetworkConnectivityState extends Equatable {
  const NetworkConnectivityState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any connectivity checks have taken place.
class NetworkConnectivityInitial extends NetworkConnectivityState {
  const NetworkConnectivityInitial();
}

/// Emitted when real, verified internet connectivity is established.
class NetworkConnectivityConnected extends NetworkConnectivityState {
  const NetworkConnectivityConnected();
}

/// Emitted when the device has lost internet connectivity (or no active interfaces).
class NetworkConnectivityDisconnected extends NetworkConnectivityState {
  const NetworkConnectivityDisconnected();
}
