import 'package:aivsol_solo_travel/core/error/failures.dart';
import 'package:aivsol_solo_travel/feature/map_picker/domain/entities/place_search_entity.dart';
import 'package:aivsol_solo_travel/feature/map_picker/domain/entities/selected_location_entity.dart';
import 'package:aivsol_solo_travel/feature/map_picker/domain/usecases/reverse_geocode_usecase.dart';
import 'package:aivsol_solo_travel/feature/map_picker/domain/usecases/search_places_usecase.dart';
import 'package:aivsol_solo_travel/feature/map_picker/presentation/bloc/map_picker_bloc.dart';
import 'package:aivsol_solo_travel/feature/map_picker/presentation/bloc/map_picker_event.dart';
import 'package:aivsol_solo_travel/feature/map_picker/presentation/bloc/map_picker_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchPlacesUseCase extends Mock implements SearchPlacesUseCase {}

class MockReverseGeocodeUseCase extends Mock implements ReverseGeocodeUseCase {}

void main() {
  late MapPickerBloc bloc;
  late MockSearchPlacesUseCase mockSearchPlacesUseCase;
  late MockReverseGeocodeUseCase mockReverseGeocodeUseCase;

  setUp(() {
    mockSearchPlacesUseCase = MockSearchPlacesUseCase();
    mockReverseGeocodeUseCase = MockReverseGeocodeUseCase();
    bloc = MapPickerBloc(
      searchPlacesUseCase: mockSearchPlacesUseCase,
      reverseGeocodeUseCase: mockReverseGeocodeUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('MapPickerBloc Tests', () {
    const tPlace = PlaceSearchEntity(
      name: 'Bengaluru',
      displayName: 'Bengaluru, Karnataka, India',
      latitude: 12.9716,
      longitude: 77.5946,
    );

    const tLocation = SelectedLocationEntity(
      address: 'Bengaluru, Karnataka, India',
      latitude: 12.9716,
      longitude: 77.5946,
    );

    test('initial state has default flags and empty lists', () {
      expect(bloc.state, const MapPickerState());
      expect(bloc.state.isSearching, false);
      expect(bloc.state.isConfirming, false);
      expect(bloc.state.searchResults, isEmpty);
    });

    test('query with length < 2 clears search results and isSearching', () async {
      bloc.add(const SearchPlacesEvent('a'));

      await expectLater(
        bloc.stream,
        emits(const MapPickerState(
          isSearching: false,
          searchResults: [],
        )),
      );

      verifyZeroInteractions(mockSearchPlacesUseCase);
    });

    test('SearchPlacesEvent emits [isSearching: true, searchResults: [...]] on success', () async {
      when(() => mockSearchPlacesUseCase.call(any(), cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => const Right([tPlace]));

      bloc.add(const SearchPlacesEvent('Bengaluru'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const MapPickerState(isSearching: true),
          const MapPickerState(
            isSearching: false,
            searchResults: [tPlace],
          ),
        ]),
      );
    });

    test('ClearSearchEvent resets search results and flags', () async {
      bloc.add(const ClearSearchEvent());

      await expectLater(
        bloc.stream,
        emits(const MapPickerState(
          isSearching: false,
          searchResults: [],
        )),
      );
    });

    test('ConfirmLocationEvent emits [isConfirming: true, confirmedLocation: tLocation] on success', () async {
      when(() => mockReverseGeocodeUseCase.call(
            latitude: 12.9716,
            longitude: 77.5946,
          )).thenAnswer((_) async => const Right(tLocation));

      bloc.add(const ConfirmLocationEvent(
        latitude: 12.9716,
        longitude: 77.5946,
      ));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const MapPickerState(isConfirming: true),
          const MapPickerState(
            isConfirming: false,
            confirmedLocation: tLocation,
          ),
        ]),
      );
    });

    test('ConfirmLocationEvent emits [isConfirming: true, confirmationError: ...] on failure', () async {
      when(() => mockReverseGeocodeUseCase.call(
            latitude: 12.9716,
            longitude: 77.5946,
          )).thenAnswer((_) async => const Left(ConnectionFailure('Network error')));

      bloc.add(const ConfirmLocationEvent(
        latitude: 12.9716,
        longitude: 77.5946,
      ));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const MapPickerState(isConfirming: true),
          const MapPickerState(
            isConfirming: false,
            confirmationError: 'Network error',
          ),
        ]),
      );
    });
  });
}
