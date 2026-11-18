import 'dart:async';
import 'package:aivsol_solo_travel/core/network/network_connectivity_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivity extends Mock implements Connectivity {}

class MockDio extends Mock implements Dio {}

void main() {
  late NetworkConnectivityManagerImpl manager;
  late MockConnectivity mockConnectivity;
  late MockDio mockDio;

  setUp(() {
    mockConnectivity = MockConnectivity();
    mockDio = MockDio();
    manager = NetworkConnectivityManagerImpl(
      connectivity: mockConnectivity,
      dio: mockDio,
      checkEndpoints: const [
        'https://endpoint1.test/204',
        'https://endpoint2.test/204',
      ],
      timeout: const Duration(milliseconds: 100),
    );
  });

  tearDown(() {
    manager.dispose();
  });

  group('NetworkConnectivityManagerImpl', () {
    test('onConnectivityChanged forwards stream from Connectivity', () async {
      final controller = StreamController<List<ConnectivityResult>>();
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => controller.stream);

      final stream = manager.onConnectivityChanged;
      expectLater(
        stream,
        emitsInOrder([
          [ConnectivityResult.wifi],
          [ConnectivityResult.none],
        ]),
      );

      controller.add([ConnectivityResult.wifi]);
      controller.add([ConnectivityResult.none]);

      await controller.close();
    });

    test('currentConnectivity returns results from Connectivity', () async {
      when(() => mockConnectivity.checkConnectivity()).thenAnswer(
        (_) async => [ConnectivityResult.mobile],
      );

      final result = await manager.currentConnectivity;
      expect(result, [ConnectivityResult.mobile]);
      verify(() => mockConnectivity.checkConnectivity()).called(1);
    });

    test('currentConnectivity returns [ConnectivityResult.none] on error', () async {
      when(() => mockConnectivity.checkConnectivity())
          .thenThrow(Exception('Platform error'));

      final result = await manager.currentConnectivity;
      expect(result, [ConnectivityResult.none]);
    });

    test('hasInternetAccess returns true when first endpoint returns 204', () async {
      when(() => mockDio.get<void>(
            'https://endpoint1.test/204',
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<void>(
          requestOptions: RequestOptions(path: 'https://endpoint1.test/204'),
          statusCode: 204,
        ),
      );

      final result = await manager.hasInternetAccess();
      expect(result, isTrue);
      verify(() => mockDio.get<void>(
            'https://endpoint1.test/204',
            options: any(named: 'options'),
          )).called(1);
      verifyNever(() => mockDio.get<void>(
            'https://endpoint2.test/204',
            options: any(named: 'options'),
          ));
    });

    test('hasInternetAccess falls back to second endpoint if first fails', () async {
      when(() => mockDio.get<void>(
            'https://endpoint1.test/204',
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'https://endpoint1.test/204'),
          type: DioExceptionType.connectionError,
        ),
      );

      when(() => mockDio.get<void>(
            'https://endpoint2.test/204',
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response<void>(
          requestOptions: RequestOptions(path: 'https://endpoint2.test/204'),
          statusCode: 200,
        ),
      );

      final result = await manager.hasInternetAccess();
      expect(result, isTrue);
      verify(() => mockDio.get<void>(
            'https://endpoint1.test/204',
            options: any(named: 'options'),
          )).called(1);
      verify(() => mockDio.get<void>(
            'https://endpoint2.test/204',
            options: any(named: 'options'),
          )).called(1);
    });

    test('hasInternetAccess returns false when all endpoints fail', () async {
      when(() => mockDio.get<void>(
            any(),
            options: any(named: 'options'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'test'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await manager.hasInternetAccess();
      expect(result, isFalse);
    });
  });
}
