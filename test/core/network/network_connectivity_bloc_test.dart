import 'dart:async';
import 'package:aivsol_solo_travel/core/network/bloc/network_connectivity_bloc.dart';
import 'package:aivsol_solo_travel/core/network/bloc/network_connectivity_state.dart';
import 'package:aivsol_solo_travel/core/network/network_connectivity_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkConnectivityManager extends Mock
    implements NetworkConnectivityManager {}

void main() {
  late MockNetworkConnectivityManager mockManager;
  late StreamController<List<ConnectivityResult>> connectivityStreamController;

  setUp(() {
    mockManager = MockNetworkConnectivityManager();
    connectivityStreamController =
        StreamController<List<ConnectivityResult>>.broadcast();

    when(() => mockManager.onConnectivityChanged)
        .thenAnswer((_) => connectivityStreamController.stream);
    when(() => mockManager.currentConnectivity)
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
    when(() => mockManager.hasInternetAccess()).thenAnswer((_) async => true);
  });

  tearDown(() {
    connectivityStreamController.close();
  });

  group('NetworkConnectivityBloc Tests', () {
    test('initial state is NetworkConnectivityInitial', () {
      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);
      expect(bloc.state, const NetworkConnectivityInitial());
      bloc.close();
    });

    test(
        'emits [NetworkConnectivityConnected] on startup when Wi-Fi has real internet',
        () async {
      when(() => mockManager.currentConnectivity)
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockManager.hasInternetAccess()).thenAnswer((_) async => true);

      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const NetworkConnectivityConnected(),
        ]),
      );

      await bloc.close();
    });

    test(
        'emits [NetworkConnectivityDisconnected] on startup when no interfaces are connected',
        () async {
      when(() => mockManager.currentConnectivity)
          .thenAnswer((_) async => [ConnectivityResult.none]);

      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const NetworkConnectivityDisconnected(),
        ]),
      );

      await bloc.close();
    });

    test(
        'emits [NetworkConnectivityDisconnected] when Wi-Fi is connected but has no actual internet',
        () async {
      when(() => mockManager.currentConnectivity)
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockManager.hasInternetAccess())
          .thenAnswer((_) async => false);

      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const NetworkConnectivityDisconnected(),
        ]),
      );

      await bloc.close();
    });

    test(
        'handles connectivity stream changes from connected to disconnected and back',
        () async {
      when(() => mockManager.currentConnectivity)
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockManager.hasInternetAccess()).thenAnswer((_) async => true);

      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);

      await expectLater(
        bloc.stream,
        emits(const NetworkConnectivityConnected()),
      );

      // Now stream emits no connectivity
      connectivityStreamController.add([ConnectivityResult.none]);

      await expectLater(
        bloc.stream,
        emits(const NetworkConnectivityDisconnected()),
      );

      // Reconnect
      connectivityStreamController.add([ConnectivityResult.mobile]);

      await expectLater(
        bloc.stream,
        emits(const NetworkConnectivityConnected()),
      );

      await bloc.close();
    });

    test('prevents repeated state emissions when connectivity has not changed',
        () async {
      when(() => mockManager.currentConnectivity)
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockManager.hasInternetAccess()).thenAnswer((_) async => true);

      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);

      await expectLater(
        bloc.stream,
        emits(const NetworkConnectivityConnected()),
      );

      final emittedStates = <NetworkConnectivityState>[];
      final subscription = bloc.stream.listen(emittedStates.add);

      // Send another connected event
      connectivityStreamController.add([ConnectivityResult.wifi]);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(emittedStates, isEmpty); // No duplicate emission

      await subscription.cancel();
      await bloc.close();
    });

    test('handles exceptions during reachability check without crashing',
        () async {
      when(() => mockManager.currentConnectivity)
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockManager.hasInternetAccess())
          .thenThrow(Exception('Socket lookup failed'));

      final bloc = NetworkConnectivityBloc(networkConnectivityManager: mockManager);

      await expectLater(
        bloc.stream,
        emits(const NetworkConnectivityDisconnected()),
      );

      await bloc.close();
    });
  });
}
