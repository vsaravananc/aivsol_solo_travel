import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/domain/entities/location_entity.dart';
import 'route_map_widget.dart';

class DetailHeaderWidget extends StatelessWidget {
  final String from;
  final String to;
  final String dateRange;
  final int days;
  final String travelStyle;
  final LocationEntity fromLocation;
  final LocationEntity destinationLocation;

  const DetailHeaderWidget({
    super.key,
    required this.from,
    required this.to,
    required this.dateRange,
    required this.days,
    required this.travelStyle,
    required this.fromLocation,
    required this.destinationLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        // Text(
        //   '$from  →  $to',
        //   style: context.textTheme.headlineMedium?.copyWith(
        //     fontWeight: FontWeight.w700,
        //   ),
        //   maxLines: 1,
        //   overflow: .fade,
        // ),
        // const SizedBox(height: 4),
        Row(
          mainAxisAlignment: .center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              '$dateRange  •  $days Days • $travelStyle',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        RouteMapWidget(
          fromName: from,
          toName: to,
          fromLocation: LatLng(fromLocation.latitude, fromLocation.longitude),
          destinationLocation: LatLng(
            destinationLocation.latitude,
            destinationLocation.longitude,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
