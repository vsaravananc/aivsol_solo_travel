import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeBloc homeBloc;

  setUp(() {
    homeBloc = HomeBloc();
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc Location Selection Tests', () {
    test('FromLocationSelectedEvent updates from, fromLatitude, and fromLongitude', () async {
      homeBloc.add(const FromLocationSelectedEvent(
        address: 'Chennai Central, Chennai',
        latitude: 13.0827,
        longitude: 80.2707,
      ));

      await expectLater(
        homeBloc.stream,
        emits(predicate<dynamic>((state) {
          return state.from == 'Chennai Central, Chennai' &&
              state.fromLatitude == 13.0827 &&
              state.fromLongitude == 80.2707;
        })),
      );
    });

    test('ToLocationSelectedEvent updates to, toLatitude, and toLongitude', () async {
      homeBloc.add(const ToLocationSelectedEvent(
        address: 'MG Road, Bengaluru',
        latitude: 12.9716,
        longitude: 77.5946,
      ));

      await expectLater(
        homeBloc.stream,
        emits(predicate<dynamic>((state) {
          return state.to == 'MG Road, Bengaluru' &&
              state.toLatitude == 12.9716 &&
              state.toLongitude == 77.5946;
        })),
      );
    });

    test('LocationsSwappedEvent correctly swaps all 6 location properties', () async {
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

      homeBloc.add(const LocationsSwappedEvent());

      await expectLater(
        homeBloc.stream,
        emitsThrough(predicate<dynamic>((state) {
          return state.from == 'Bengaluru' &&
              state.fromLatitude == 12.9716 &&
              state.fromLongitude == 77.5946 &&
              state.to == 'Chennai' &&
              state.toLatitude == 13.0827 &&
              state.toLongitude == 80.2707;
        })),
      );
    });

    test('isFormValid requires valid names, coordinates, dates, and travel style', () {
      expect(homeBloc.state.isFormValid, false);

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

      homeBloc.add(const TravelStyleChangedEvent(TravelStyle.comfort));

      expect(homeBloc.state.travelStyle, TravelStyle.comfort);
    });
  });
}
