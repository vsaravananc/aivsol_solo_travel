import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_event.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_state.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/save_trip_history_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/save_trip_history_event.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/save_trip_history_state.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_event.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_state.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_budget_section_widget.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_header_widget.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_share_sheet_widget.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/widgets/detail_weather_section_widget.dart';
import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatefulWidget {
  final String from;
  final String to;
  final String toPlace;
  final String dateRange;
  final int days;
  final TravelStyle travelStyleEnum;
  final LocationEntity fromLocation;
  final LocationEntity destinationLocation;
  final DateTime startDate;
  final DateTime endDate;

  const DetailScreen({
    super.key,
    required this.from,
    required this.to,
    required this.toPlace,
    required this.dateRange,
    required this.days,
    required this.travelStyleEnum,
    required this.fromLocation,
    required this.destinationLocation,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _estimateBudget();
  }

  void _fetchWeather() {
    context.read<WeatherBloc>().add(
      FetchWeatherEvent(
        destinationLocation: widget.destinationLocation,
        startDate: widget.startDate,
        endDate: widget.endDate,
      ),
    );
  }

  void _estimateBudget() {
    context.read<EstimateBudgetBloc>().add(
      EstimateBudgetCalculationEvent(
        fromLocation: widget.fromLocation,
        toLocation: widget.destinationLocation,
        startDate: widget.startDate,
        endDate: widget.endDate,
        travelStyle: widget.travelStyleEnum,
      ),
    );
  }

  /// Attempts to persist the trip once budget is ready.
  /// Weather is optional — save proceeds even if weather failed.
  void _trySaveTripHistory({
    required EstimateBudgetState budgetState,
    required WeatherState weatherState,
  }) {
    // Budget must be resolved before we can save.
    if (budgetState is! EstimateBudgetSuccess) return;

    // Skip if already saved.
    final saveState = context.read<SaveTripHistoryBloc>().state;
    if (saveState is TripHistorySaved) return;

    context.read<SaveTripHistoryBloc>().add(
      SaveTripHistoryRequested(
        from: widget.fromLocation,
        to: widget.destinationLocation,
        startDate: widget.startDate,
        endDate: widget.endDate,
        travelStyle: widget.travelStyleEnum,
        budget: budgetState.budget,
        // Pass weather only when available; null is accepted by the usecase.
        weather: weatherState is WeatherSuccess ? weatherState.weather : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveTripHistoryBloc>(
      create: (_) => GetIt.instance<SaveTripHistoryBloc>(),
      child: BlocListener<SaveTripHistoryBloc, SaveTripHistoryState>(
        listener: (context, saveState) {
          // Optional: react to save result (e.g., log or show a snack).
          // Currently silent — the save is a background side-effect.
        },
        child: BlocListener<EstimateBudgetBloc, EstimateBudgetState>(
          listener: (context, budgetState) {
            _trySaveTripHistory(
              budgetState: budgetState,
              weatherState: context.read<WeatherBloc>().state,
            );
          },
          child: BlocListener<WeatherBloc, WeatherState>(
            listener: (context, weatherState) {
              _trySaveTripHistory(
                budgetState: context.read<EstimateBudgetBloc>().state,
                weatherState: weatherState,
              );
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    context.read<HomeBloc>().add(const RevertSelectedEvent());
                    context.pop();
                  },
                ),
                title: const Text('Trip Detail'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => DetailShareSheetWidget.show(
                        context,
                        from: widget.from,
                        to: widget.to,
                        dateRange: widget.dateRange,
                        days: widget.days,
                        travelStyle: widget.travelStyleEnum.name,
                        endDate: widget.endDate,
                        startDate: widget.startDate,
                      ),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.share,
                          color: context.themeData.scaffoldBackgroundColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailHeaderWidget(
                      from: widget.from,
                      to: widget.to,
                      dateRange: widget.dateRange,
                      days: widget.days,
                      travelStyle: widget.travelStyleEnum.name,
                    ),
                    DetailBudgetSectionWidget(onRetry: _estimateBudget),
                    DetailWeatherSectionWidget(
                      cityName: widget.toPlace,
                      onRetry: _fetchWeather,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
