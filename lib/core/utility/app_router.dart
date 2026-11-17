import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/screen/detail_screen.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/screen/history_recent_search_trips.dart';
import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/screen/home_sreen.dart';
import 'package:aivsol_solo_travel/feature/map/presentation/screen/map_screen.dart';
import 'package:aivsol_solo_travel/main.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final String initalRoute = '/';
  static final String homeRoute = '/home';
  static final String detailRoute = '/detail';
  static final String historyRoute = '/history';
  static final String mapRoute = '/map';

  GoRouter get router => _goRouter;
  final GoRouter _goRouter = GoRouter(
    initialLocation: initalRoute,
    routes: [
      GoRoute(
        path: initalRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: historyRoute,
        builder: (context, state) => const HistoryRecentSearchTrips(),
      ),
      GoRoute(
        path: mapRoute,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: detailRoute,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DetailScreen(
            id: extra['id'] as int?,
            useLocalData: extra['useLocalData'] as bool? ?? false,
            from: extra['from'] as String,
            to: extra['to'] as String,
            toPlace: extra['toPlace'] as String,
            dateRange: extra['dateRange'] as String,
            days: extra['days'] as int,
            travelStyleEnum: extra['travelStyleEnum'] as TravelStyle,
            fromLocation: extra['fromLocation'] as LocationEntity,
            destinationLocation: extra['destinationLocation'] as LocationEntity,
            startDate: extra['startDate'] as DateTime,
            endDate: extra['endDate'] as DateTime,
          );
        },
      ),
    ],
  );
}
