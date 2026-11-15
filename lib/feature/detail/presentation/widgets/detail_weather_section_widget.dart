import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/weather_code_helper.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/daily_weather_entity.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_bloc.dart';
import 'package:aivsol_solo_travel/feature/detail/presentation/bloc/weather_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailWeatherSectionWidget extends StatelessWidget {
  final String cityName;
  final VoidCallback? onRetry;

  const DetailWeatherSectionWidget({
    super.key,
    this.cityName = 'Varkala',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather in $cityName',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.themeData.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.themeData.disabledColor.withAlpha(12),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.themeData.shadowColor.withAlpha(16),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                return switch (state) {
                  WeatherInitial() => const _WeatherInitialWidget(),
                  WeatherLoading() => const _WeatherLoadingWidget(),
                  WeatherFailure() => _WeatherFailureWidget(
                    errorMessage: state.errorMessage,
                    onRetry: onRetry,
                  ),
                  WeatherSuccess() => _WeatherSuccessWidget(state: state),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherInitialWidget extends StatelessWidget {
  const _WeatherInitialWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          'Weather information ready to load.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _WeatherLoadingWidget extends StatelessWidget {
  const _WeatherLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            SizedBox(height: 12),
            Text(
              'Fetching forecast...',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherFailureWidget extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;

  const _WeatherFailureWidget({required this.errorMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 36, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weather unavailable',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  errorMessage ?? 'Could not fetch current forecast.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 22),
              tooltip: 'Retry weather',
              onPressed: onRetry,
            ),
        ],
      ),
    );
  }
}

class _WeatherSuccessWidget extends StatelessWidget {
  final WeatherSuccess state;

  const _WeatherSuccessWidget({required this.state});

  @override
  Widget build(BuildContext context) {
    final weather = state.weather;
    final current = weather.currentWeather;
    final daily = weather.dailyWeather;

    final conditionText = WeatherCodeHelper.getDescription(current.weatherCode);

    final conditionIcon = WeatherCodeHelper.getIcon(current.weatherCode);

    final highTemp = daily.isNotEmpty
        ? '${daily.first.maxTemperature.round()}°'
        : '--';

    final lowTemp = daily.isNotEmpty
        ? '${daily.first.minTemperature.round()}°'
        : '--';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CurrentWeatherWidget(
          temperature: current.temperature,
          conditionText: conditionText,
          conditionIcon: conditionIcon,
          highTemperature: highTemp,
          lowTemperature: lowTemp,
          humidity: current.relativeHumidity,
        ),
        const SizedBox(height: 14),
        Divider(height: 1, color: context.themeData.dividerColor.withAlpha(60)),
        const SizedBox(height: 12),
        _WeatherForecastWidget(daily: daily),
        const SizedBox(height: 8),
        Text(
          'Showing first ${daily.length} days of '
          '${state.totalTripDays}-day trip forecast.',
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _CurrentWeatherWidget extends StatelessWidget {
  final double temperature;
  final String conditionText;
  final IconData conditionIcon;
  final String highTemperature;
  final String lowTemperature;
  final int humidity;

  const _CurrentWeatherWidget({
    required this.temperature,
    required this.conditionText,
    required this.conditionIcon,
    required this.highTemperature,
    required this.lowTemperature,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(conditionIcon, size: 32, color: Colors.orange),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${temperature.toStringAsFixed(1)}°C $conditionText',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'High $highTemperature  •  Low $lowTemperature',
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Humidity',
              style: context.textTheme.bodySmall?.copyWith(
                letterSpacing: 0.6,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '$humidity%',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeatherForecastWidget extends StatelessWidget {
  final List<DailyWeatherEntity> daily;

  const _WeatherForecastWidget({required this.daily});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: daily
            .map(
              (forecast) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _ForecastDayWidget(forecast: forecast),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ForecastDayWidget extends StatelessWidget {
  final DailyWeatherEntity forecast;

  const _ForecastDayWidget({required this.forecast});

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final dayLabel = _weekdays[forecast.date.weekday - 1];
    final icon = WeatherCodeHelper.getIcon(forecast.weatherCode);

    return Column(
      spacing: 4,
      children: [
        Text(
          dayLabel,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Icon(icon, size: 20, color: Colors.orange),
        Text(
          '${forecast.maxTemperature.round()}°',
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
