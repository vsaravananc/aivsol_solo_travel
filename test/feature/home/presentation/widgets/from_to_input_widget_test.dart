import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/from_to_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeBloc homeBloc;

  setUp(() {
    homeBloc = HomeBloc();
  });

  tearDown(() {
    homeBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: LightTheme.themeData,
      home: Scaffold(
        body: BlocProvider<HomeBloc>.value(
          value: homeBloc,
          child: const FromToInputWidget(),
        ),
      ),
    );
  }

  group('FromToInputWidget Redesign Tests', () {
    testWidgets('renders From and To read-only fields with map placeholders', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('From'), findsOneWidget);
      expect(find.text('To'), findsOneWidget);
      expect(find.text('Tap to select departure on map'), findsOneWidget);
      expect(find.text('Tap to select destination on map'), findsOneWidget);

      // Verify TextFormField is completely removed (no keyboard input)
      expect(find.byType(TextFormField), findsNothing);
      expect(find.byType(EditableText), findsNothing);
      expect(find.byIcon(Icons.swap_vert_rounded), findsOneWidget);
      expect(find.byIcon(Icons.map_outlined), findsNWidgets(2));
    });

    testWidgets('displays selected addresses from HomeBloc state', (tester) async {
      homeBloc.add(const FromLocationSelectedEvent(
        address: 'Chennai Central Station',
        latitude: 13.0827,
        longitude: 80.2707,
      ));
      homeBloc.add(const ToLocationSelectedEvent(
        address: 'Bengaluru Airport',
        latitude: 12.9716,
        longitude: 77.5946,
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Chennai Central Station'), findsOneWidget);
      expect(find.text('Bengaluru Airport'), findsOneWidget);
    });

    testWidgets('tapping swap button swaps locations in HomeBloc', (tester) async {
      homeBloc.add(const FromLocationSelectedEvent(
        address: 'Chennai',
        latitude: 13.0827,
        longitude: 80.2707,
      ));
      homeBloc.add(const ToLocationSelectedEvent(
        address: 'Bengaluru',
        latitude: 12.9716,
        longitude: 77.5946,
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.swap_vert_rounded));
      await tester.pumpAndSettle();

      expect(homeBloc.state.from, 'Bengaluru');
      expect(homeBloc.state.fromLatitude, 12.9716);
      expect(homeBloc.state.fromLongitude, 77.5946);
      expect(homeBloc.state.to, 'Chennai');
      expect(homeBloc.state.toLatitude, 13.0827);
      expect(homeBloc.state.toLongitude, 80.2707);
    });
  });
}
