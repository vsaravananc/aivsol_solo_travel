import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/app_router.dart';
import 'package:aivsol_solo_travel/feature/detail/domain/entities/trip_history_entity.dart';
import 'package:aivsol_solo_travel/feature/home/domain/entities/location_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryTripCardWidget extends StatelessWidget {
  final TripHistoryEntity trip;

  const HistoryTripCardWidget({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final costFormatted =
        '₹${trip.totalCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

    return GestureDetector(
      onTap: () {
        final dateFormatter = DateFormat('MMM d');
        final dateRange =
            '${dateFormatter.format(trip.startDate)} – ${dateFormatter.format(trip.endDate)}';

        context.push(
          AppRouter.detailRoute,
          extra: {
            'id': trip.id,
            'useLocalData': true,
            'from': trip.fromLocation,
            'to': trip.toLocation,
            'toPlace': trip.toLocation,
            'dateRange': dateRange,
            'days': trip.tripDays,
            'travelStyleEnum': trip.travelStyle,
            'fromLocation': LocationEntity(
              name: trip.fromLocation,
              latitude: trip.fromLat,
              longitude: trip.fromLong,
            ),
            'destinationLocation': LocationEntity(
              name: trip.toLocation,
              latitude: trip.toLat,
              longitude: trip.toLong,
            ),
            'startDate': trip.startDate,
            'endDate': trip.endDate,
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
                    '${trip.fromLocation}  →  ${trip.toLocation}',
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
                        '${trip.tripDays} Days',
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
