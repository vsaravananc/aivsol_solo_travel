import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class _DayForecast {
  final String day;
  final int temp;
  final IconData icon;

  const _DayForecast({
    required this.day,
    required this.temp,
    required this.icon,
  });
}

const _forecast = [
  _DayForecast(day: 'Thu', temp: 28, icon: Icons.wb_sunny_outlined),
  _DayForecast(day: 'Fri', temp: 29, icon: Icons.wb_sunny_outlined),
  _DayForecast(day: 'Sat', temp: 27, icon: Icons.wb_cloudy_outlined),
  _DayForecast(day: 'Sun', temp: 28, icon: Icons.wb_sunny_outlined),
  _DayForecast(day: 'Mon', temp: 29, icon: Icons.wb_sunny_outlined),
];

class DetailWeatherSectionWidget extends StatelessWidget {
  const DetailWeatherSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(top: 20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            'Weather in varkala',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const .all(14),
            decoration: BoxDecoration(
              color: context.themeData.scaffoldBackgroundColor,
              borderRadius: .circular(16),
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
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      size: 32,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '28°C Partly Sunny',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'High 31°  •  Low 24°',
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
                          '72%',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: context.themeData.dividerColor.withAlpha(60),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _forecast
                      .map((f) => _ForecastDayWidget(forecast: f))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastDayWidget extends StatelessWidget {
  final _DayForecast forecast;

  const _ForecastDayWidget({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Text(
          forecast.day,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Icon(forecast.icon, size: 20, color: Colors.orange),
        Text(
          '${forecast.temp}°',
          style: context.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
