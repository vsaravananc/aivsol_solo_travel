import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

abstract class NetworkConnectivityManager {
  /// Stream of network connectivity changes (Wi-Fi, cellular, ethernet, etc.).
  Stream<List<ConnectivityResult>> get onConnectivityChanged;

  /// Current device connectivity state.
  Future<List<ConnectivityResult>> get currentConnectivity;

  /// Verifies actual internet reachability via lightweight HTTP verification.
  Future<bool> hasInternetAccess();

  /// Releases resources.
  void dispose();
}

class NetworkConnectivityManagerImpl implements NetworkConnectivityManager {
  final Connectivity _connectivity;
  final Dio _dio;
  final List<String> _checkEndpoints;
  final Duration _timeout;

  NetworkConnectivityManagerImpl({
    Connectivity? connectivity,
    Dio? dio,
    List<String>? checkEndpoints,
    Duration timeout = const Duration(seconds: 3),
  })  : _connectivity = connectivity ?? Connectivity(),
        _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: timeout,
                receiveTimeout: timeout,
                sendTimeout: timeout,
              ),
            ),
        _checkEndpoints = checkEndpoints ??
            const [
              'https://connectivitycheck.gstatic.com/generate_204',
              'https://clients3.google.com/generate_204',
            ],
        _timeout = timeout;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  @override
  Future<List<ConnectivityResult>> get currentConnectivity async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (_) {
      return const [ConnectivityResult.none];
    }
  }

  @override
  Future<bool> hasInternetAccess() async {
    for (final endpoint in _checkEndpoints) {
      try {
        final response = await _dio.get<void>(
          endpoint,
          options: Options(
            responseType: ResponseType.plain,
            sendTimeout: _timeout,
            receiveTimeout: _timeout,
            validateStatus: (status) => status != null && status < 400,
          ),
        );

        // HTTP 204 (No Content) or 200 (OK) confirms successful network roundtrip
        if (response.statusCode == 204 || response.statusCode == 200) {
          return true;
        }
      } catch (_) {
        // Continue to fallback endpoint if available
      }
    }
    return false;
  }

  @override
  void dispose() {
    _dio.close(force: true);
  }
}
