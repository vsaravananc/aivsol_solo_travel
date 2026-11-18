import 'dart:async';
import 'package:aivsol_solo_travel/core/network/bloc/network_connectivity_bloc.dart';
import 'package:aivsol_solo_travel/core/network/bloc/network_connectivity_state.dart';
import 'package:aivsol_solo_travel/core/widgets/network_connectivity_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkConnectivityBloc
    extends Mock implements NetworkConnectivityBloc {}

void main() {
  late MockNetworkConnectivityBloc mockBloc;
  late StreamController<NetworkConnectivityState> stateController;
  late GlobalKey<ScaffoldMessengerState> messengerKey;

  setUp(() {
    mockBloc = MockNetworkConnectivityBloc();
    stateController = StreamController<NetworkConnectivityState>.broadcast();
    messengerKey = GlobalKey<ScaffoldMessengerState>();

    when(() => mockBloc.stream).thenAnswer((_) => stateController.stream);
    when(() => mockBloc.state).thenReturn(const NetworkConnectivityInitial());
  });

  tearDown(() {
    stateController.close();
  });

  Widget buildTestWidget({Duration debounce = const Duration(milliseconds: 200)}) {
    return BlocProvider<NetworkConnectivityBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        scaffoldMessengerKey: messengerKey,
        home: Scaffold(
          body: NetworkConnectivityListener(
            debounceDuration: debounce,
            messengerKey: messengerKey,
            child: const Text('App Content'),
          ),
        ),
      ),
    );
  }

  group('NetworkConnectivityListener Tests', () {
    testWidgets('renders child widget normally', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.text('App Content'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('does not show offline snackbar immediately on disconnect (debounced)',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(debounce: const Duration(milliseconds: 500)),
      );

      // Transition to Disconnected
      when(() => mockBloc.state).thenReturn(const NetworkConnectivityDisconnected());
      stateController.add(const NetworkConnectivityDisconnected());
      await tester.pump();

      // Immediately after disconnect, offline snackbar should NOT be visible yet
      expect(find.byType(SnackBar), findsNothing);

      // Advance by 200ms (still within debounce window)
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(SnackBar), findsNothing);

      // Advance past remaining debounce window
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('No internet connection. Please check your network.'),
        findsOneWidget,
      );
    });

    testWidgets(
        'cancels offline notification if connection restored within debounce window',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(debounce: const Duration(milliseconds: 500)),
      );

      // Disconnect
      when(() => mockBloc.state).thenReturn(const NetworkConnectivityDisconnected());
      stateController.add(const NetworkConnectivityDisconnected());
      await tester.pump();

      // Wait 200ms (before debounce completes)
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(SnackBar), findsNothing);

      // Reconnect within debounce window
      when(() => mockBloc.state).thenReturn(const NetworkConnectivityConnected());
      stateController.add(const NetworkConnectivityConnected());
      await tester.pump();

      // Wait past the original 500ms debounce
      await tester.pump(const Duration(milliseconds: 400));

      // No Snackbar should ever have been shown!
      expect(find.byType(SnackBar), findsNothing);
      expect(find.text('Back online'), findsNothing);
    });

    testWidgets(
        'shows "Back online" snackbar for 2 seconds after offline snackbar was shown',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(debounce: const Duration(milliseconds: 100)),
      );

      // Disconnect
      when(() => mockBloc.state).thenReturn(const NetworkConnectivityDisconnected());
      stateController.add(const NetworkConnectivityDisconnected());
      await tester.pump();

      // Wait past debounce
      await tester.pump(const Duration(milliseconds: 150));
      expect(
        find.text('No internet connection. Please check your network.'),
        findsOneWidget,
      );

      // Reconnect
      when(() => mockBloc.state).thenReturn(const NetworkConnectivityConnected());
      stateController.add(const NetworkConnectivityConnected());
      await tester.pump();

      // Offline snackbar is dismissed, "Back online" is shown
      expect(
        find.text('No internet connection. Please check your network.'),
        findsNothing,
      );
      expect(find.text('Back online'), findsOneWidget);

      // After 2 seconds, "Back online" auto-dismisses
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 500)); // animation settle
      expect(find.text('Back online'), findsNothing);
    });
  });
}
