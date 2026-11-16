import 'package:aivsol_solo_travel/core/di/injection_container.dart';
import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/usecases/get_trip_history_by_id.dart';
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
import 'package:aivsol_solo_travel/feature/history/presentation/bloc/history_bloc.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/bloc/history_event.dart';
import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/home_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/recent_trips_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/recent_trips_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatefulWidget {
  final int? id;
  final bool useLocalData;
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
    this.id,
    this.useLocalData = false,
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
    if (widget.useLocalData && widget.id != null) {
      _loadFromLocalDatabase(widget.id!);
    } else {
      _fetchWeather();
      _estimateBudget();
    }
  }

  Future<void> _loadFromLocalDatabase(int id) async {
    final getTripHistoryById = sl<GetTripHistoryById>();
    final result = await getTripHistoryById(id);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      (trip) {
        if (trip != null && mounted) {
          context.read<EstimateBudgetBloc>().add(
            LoadLocalBudgetEvent(
              budget: trip.toBudgetEntity,
              travelStyle: trip.travelStyle,
            ),
          );
          context.read<WeatherBloc>().add(
            LoadLocalWeatherEvent(
              weather: trip.toWeatherEntity,
              totalTripDays: trip.tripDays,
            ),
          );
        }
      },
    );
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

  void _trySaveTripHistory({
    required EstimateBudgetState budgetState,
    required WeatherState weatherState,
  }) {
    context.read<HomeBloc>().add(const RevertSelectedEvent());
    if (widget.useLocalData) return;
    if (budgetState is! EstimateBudgetSuccess) return;

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
        weather: weatherState is WeatherSuccess ? weatherState.weather : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveTripHistoryBloc, SaveTripHistoryState>(
      listener: (context, state) {
        if (state is TripHistorySaved) {
          context.read<RecentTripsBloc>().add(const FetchRecentTripsEvent());
          context.read<HistoryBloc>().add(const FetchAllTripHistoryEvent());
        }
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
                DetailBudgetSectionWidget(
                  onRetry: widget.useLocalData && widget.id != null
                      ? () => _loadFromLocalDatabase(widget.id!)
                      : _estimateBudget,
                ),
                DetailWeatherSectionWidget(
                  cityName: widget.toPlace,
                  onRetry: widget.useLocalData && widget.id != null
                      ? () => _loadFromLocalDatabase(widget.id!)
                      : _fetchWeather,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
