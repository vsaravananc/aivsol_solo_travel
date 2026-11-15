import 'dart:io';
import 'package:aivsol_solo_travel/core/di/injection_container.dart';
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/app_router.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/location_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const AivsolSoloTravel());
}

class AivsolSoloTravel extends StatelessWidget {
  const AivsolSoloTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<HomeBloc>()),
        BlocProvider(create: (context) => sl<LocationBloc>()),
        BlocProvider<WeatherBloc>.value(value: sl<WeatherBloc>()),
        BlocProvider<EstimateBudgetBloc>.value(value: sl<EstimateBudgetBloc>()),
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter().router,
        theme: LightTheme.themeData,
        title: 'Aivsol Solo Travel',
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        context.go(AppRouter.homeRoute);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Container(
                  padding: const .all(12),
                  decoration: BoxDecoration(
                    borderRadius: .circular(6),
                    color: context.themeData.primaryColor,
                  ),
                  child: Icon(
                    CupertinoIcons.location_fill,
                    color: context.themeData.scaffoldBackgroundColor,
                  ),
                )
                .animate()
                .scale(
                  delay: const Duration(milliseconds: 200),
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                )
                .fade(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: Platform.isAndroid ? 8 : 0),
        child: SafeArea(
          child: RichText(
            textAlign: .center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Developed by\n',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.themeData.colorScheme.secondary,
                    fontWeight: .w600,
                    height: 1.3,
                  ),
                ),
                TextSpan(
                  text: 'Saravanan V',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.themeData.colorScheme.secondary,
                    fontWeight: .w500,
                  ),
                ),
              ],
            ),
          ).animate().slide(begin: const Offset(0, .9), end: .zero).fade(),
        ),
      ),
    );
  }
}
