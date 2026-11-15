import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/app_router.dart';
import 'package:aivsol_solo_travel/core/widgets/trip_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecentTrip {
  final String from;
  final String to;
  final int days;
  final double estimatedCost;

  const RecentTrip({
    required this.from,
    required this.to,
    required this.days,
    required this.estimatedCost,
  });
}

const _dummyTrips = [
  RecentTrip(from: 'Mumbai', to: 'Goa', days: 3, estimatedCost: 8400),
  RecentTrip(from: 'Kochi', to: 'Munnar', days: 2, estimatedCost: 5200),
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
                onTap: () => context.push(AppRouter.historyRoute),
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
                TripCard(trip: _dummyTrips[index]),
          ),
        ],
      ),
    );
  }
}
