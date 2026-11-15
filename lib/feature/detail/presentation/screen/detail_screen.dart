import 'package:aivsol_solo_travel/core/enums/travel_style.dart';
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/estimate_budget_event.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_event.dart';
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
    final destination = widget.destinationLocation;
    final start = widget.startDate;
    final end = widget.endDate;

    context.read<WeatherBloc>().add(
      FetchWeatherEvent(
        destinationLocation: destination,
        startDate: start,
        endDate: end,
      ),
    );
  }

  void _estimateBudget() {
    final from = widget.fromLocation;
    final to = widget.destinationLocation;
    final start = widget.startDate;
    final end = widget.endDate;
    final style = widget.travelStyleEnum;

    context.read<EstimateBudgetBloc>().add(
      EstimateBudgetCalculationEvent(
        fromLocation: from,
        toLocation: to,
        startDate: start,
        endDate: end,
        travelStyle: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: .circle,
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
          crossAxisAlignment: .start,
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
    );
  }
}
