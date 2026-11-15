import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class _RecentTrip {
  final String from;
  final String to;
  final int days;
  final double estimatedCost;

  const _RecentTrip({
    required this.from,
    required this.to,
    required this.days,
    required this.estimatedCost,
  });
}

const _dummyTrips = [
  _RecentTrip(from: 'Mumbai', to: 'Goa', days: 3, estimatedCost: 8400),
  _RecentTrip(from: 'Kochi', to: 'Munnar', days: 2, estimatedCost: 5200),
];

class RecentlySearchTripsWidget extends StatelessWidget {
  const RecentlySearchTripsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently searched trips',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyTrips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _TripCard(trip: _dummyTrips[index]),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final _RecentTrip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final costFormatted =
        '₹${trip.estimatedCost.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';

    return GestureDetector(
      onTap: () {},
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
                      Text('${trip.days} Days', style: context.textTheme.bodyMedium),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text('•', style: TextStyle(color: AppColors.textSecondary)),
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
