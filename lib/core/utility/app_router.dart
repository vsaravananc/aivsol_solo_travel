import 'package:aivsol_solo_travel/feature/home/presentation/screen/home_sreen.dart';
import 'package:aivsol_solo_travel/main.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final String initalRoute = '/';
  static final String homeRoute ='/home';

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
    ],
  );
}
