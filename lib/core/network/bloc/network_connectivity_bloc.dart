import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network_connectivity_manager.dart';
import 'network_connectivity_event.dart';
import 'network_connectivity_state.dart';

class NetworkConnectivityBloc
    extends Bloc<NetworkConnectivityEvent, NetworkConnectivityState> {
  final NetworkConnectivityManager networkConnectivityManager;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  NetworkConnectivityBloc({
    required this.networkConnectivityManager,
  }) : super(const NetworkConnectivityInitial()) {
    on<NetworkConnectivityStarted>(_onStarted);
    on<NetworkConnectivityChanged>(_onChanged);

    add(const NetworkConnectivityStarted());
  }

  Future<void> _onStarted(
    NetworkConnectivityStarted event,
    Emitter<NetworkConnectivityState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = networkConnectivityManager.onConnectivityChanged.listen(
      (results) {
        add(NetworkConnectivityChanged(results));
      },
      onError: (_) {
        add(const NetworkConnectivityChanged([ConnectivityResult.none]));
      },
    );

    try {
      final initialResults =
          await networkConnectivityManager.currentConnectivity;
      add(NetworkConnectivityChanged(initialResults));
    } catch (_) {
      add(const NetworkConnectivityChanged([ConnectivityResult.none]));
    }
  }

  Future<void> _onChanged(
    NetworkConnectivityChanged event,
    Emitter<NetworkConnectivityState> emit,
  ) async {
    final hasActiveInterface = event.results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (!hasActiveInterface) {
      if (state is! NetworkConnectivityDisconnected) {
        emit(const NetworkConnectivityDisconnected());
      }
      return;
    }

    try {
      final hasInternet =
          await networkConnectivityManager.hasInternetAccess();
      if (hasInternet) {
        if (state is! NetworkConnectivityConnected) {
          emit(const NetworkConnectivityConnected());
        }
      } else {
        if (state is! NetworkConnectivityDisconnected) {
          emit(const NetworkConnectivityDisconnected());
        }
      }
    } catch (_) {
      if (state is! NetworkConnectivityDisconnected) {
        emit(const NetworkConnectivityDisconnected());
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    return super.close();
  }
}
