
import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/core/utility/app_router.dart';
import 'package:aivsol_solo_travel/core/widgets/trip_card_widget.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/recent_trips_bloc.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/recent_trips_event.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/bloc/recent_trips_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecentlySearchTripsWidget extends StatefulWidget {
  const RecentlySearchTripsWidget({super.key});

  @override
  State<RecentlySearchTripsWidget> createState() =>
      _RecentlySearchTripsWidgetState();
}

class _RecentlySearchTripsWidgetState
    extends State<RecentlySearchTripsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<RecentTripsBloc>().add(
      const FetchRecentTripsEvent(limit: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentTripsBloc, RecentTripsState>(
      builder: (context, state) {
        if (state is RecentTripsLoading ||
            state is RecentTripsInitial) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        // Hide the entire section when fetching fails.
        if (state is RecentTripsFailure) {
          return const SizedBox.shrink();
        }

        if (state is RecentTripsLoaded) {
          // Hide the entire section when there are no trips.
          if (state.trips.isEmpty) {
            return const SizedBox.shrink();
          }

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
                      onTap: () =>
                          context.push(AppRouter.historyRoute),
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
                  itemCount: state.trips.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      TripCard(trip: state.trips[index]),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
