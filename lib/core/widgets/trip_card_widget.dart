import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/app_router.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/recently_search_trips_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripCard extends StatelessWidget {
  final RecentTrip trip;

  const TripCard({required this.trip, super.key});

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
            'fromCode': trip.from.substring(0, 3).toUpperCase(),
            'toPlace': trip.to,
            'dateRange': 'Nov 14 – Nov 18',
            'days': trip.days,
            'travelStyle': 'Standard Style',
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
                      Text(costFormatted, style: context.textTheme.bodyMedium),
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
