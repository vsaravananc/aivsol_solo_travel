import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/bloc/network_connectivity_bloc.dart';
import '../network/bloc/network_connectivity_state.dart';
import '../utility/scaffold_messenger_key.dart';
import 'network_snackbar.dart';

/// A global listener widget that observes [NetworkConnectivityBloc] state transitions,
/// debounces offline notifications by 2 seconds to avoid UI flickering, and presents
/// persistent offline or auto-dismissing online Snackbars.
class NetworkConnectivityListener extends StatefulWidget {
  final Widget child;
  final Duration debounceDuration;
  final GlobalKey<ScaffoldMessengerState>? messengerKey;

  const NetworkConnectivityListener({
    super.key,
    required this.child,
    this.debounceDuration = const Duration(seconds: 2),
    this.messengerKey,
  });

  @override
  State<NetworkConnectivityListener> createState() =>
      _NetworkConnectivityListenerState();
}

class _NetworkConnectivityListenerState
    extends State<NetworkConnectivityListener> {
  Timer? _offlineDebounceTimer;
  bool _isOfflineSnackbarVisible = false;

  ScaffoldMessengerState? get _messenger {
    if (widget.messengerKey?.currentState != null) {
      return widget.messengerKey!.currentState;
    }
    if (rootScaffoldMessengerKey.currentState != null) {
      return rootScaffoldMessengerKey.currentState;
    }
    try {
      return ScaffoldMessenger.maybeOf(context);
    } catch (_) {
      return null;
    }
  }

  void _onConnectivityStateChanged(
    BuildContext context,
    NetworkConnectivityState state,
  ) {
    final messenger = _messenger;

    if (state is NetworkConnectivityDisconnected) {
      // Avoid duplicate timers if disconnected event is re-received or already visible
      if (_isOfflineSnackbarVisible || _offlineDebounceTimer?.isActive == true) {
        return;
      }

      // Debounce offline notification by 2 seconds
      _offlineDebounceTimer = Timer(widget.debounceDuration, () {
        if (!mounted) return;
        _offlineDebounceTimer = null;
        if (messenger != null) {
          messenger.clearSnackBars();
          messenger.showSnackBar(NetworkSnackbar.buildOfflineSnackBar());
          _isOfflineSnackbarVisible = true;
        }
      });
    } else if (state is NetworkConnectivityConnected) {
      // 1. Cancel pending offline notification if connection restored within debounce window
      if (_offlineDebounceTimer?.isActive == true) {
        _offlineDebounceTimer?.cancel();
        _offlineDebounceTimer = null;
      }

      // 2. If the offline notification was actually shown, dismiss it and display "Back online"
      if (_isOfflineSnackbarVisible) {
        _isOfflineSnackbarVisible = false;
        if (messenger != null) {
          messenger.clearSnackBars();
          messenger.showSnackBar(NetworkSnackbar.buildOnlineSnackBar());
        }
      }
    }
  }

  @override
  void dispose() {
    _offlineDebounceTimer?.cancel();
    _offlineDebounceTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkConnectivityBloc, NetworkConnectivityState>(
      listener: _onConnectivityStateChanged,
      child: widget.child,
    );
  }
}
