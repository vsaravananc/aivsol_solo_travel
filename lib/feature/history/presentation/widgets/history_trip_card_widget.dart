import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripHistoryItem {
  final String from;
  final String to;
  final int days;
  final double estimatedCost;
  final String dateRange;
  final String travelStyle;

  const TripHistoryItem({
    required this.from,
    required this.to,
    required this.days,
    required this.estimatedCost,
    required this.dateRange,
    required this.travelStyle,
  });
}

class HistoryTripCardWidget extends StatelessWidget {
  final TripHistoryItem trip;

  const HistoryTripCardWidget({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final costFormatted =
        '₹${trip.estimatedCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

    return GestureDetector(
      onTap: () {
        context.push(
          AppRouter.detailRoute,
          extra: {
            'from': trip.from,
            'to': trip.to,
            'fromCode': trip.from.length >= 3
                ? trip.from.substring(0, 3).toUpperCase()
                : trip.from.toUpperCase(),
            'toPlace': trip.to,
            'dateRange': trip.dateRange,
            'days': trip.days,
            'travelStyle': trip.travelStyle,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: context.themeData.disabledColor.withAlpha(12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: context.themeData.shadowColor.withAlpha(20),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trip.from}  →  ${trip.to}',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${trip.days} Days',
                        style: context.textTheme.bodyMedium,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '•',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                      Text(
                        costFormatted,
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.themeData.disabledColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
