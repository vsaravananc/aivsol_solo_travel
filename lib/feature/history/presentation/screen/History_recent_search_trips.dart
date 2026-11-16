import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/bloc/history_bloc.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/bloc/history_event.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/bloc/history_state.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/widgets/history_trip_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryRecentSearchTrips extends StatefulWidget {
  const HistoryRecentSearchTrips({super.key});

  @override
  State<HistoryRecentSearchTrips> createState() =>
      _HistoryRecentSearchTripsState();
}

class _HistoryRecentSearchTripsState extends State<HistoryRecentSearchTrips> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const FetchAllTripHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recent Searches'),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is HistoryFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  state.errorMessage,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.red.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is HistoryLoaded) {
            if (state.trips.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Your trip history will be saved automatically. Just generate your first trip to get started!',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: .center,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: state.trips.length,
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 50,
              ),
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) =>
                  HistoryTripCardWidget(trip: state.trips[index]),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
