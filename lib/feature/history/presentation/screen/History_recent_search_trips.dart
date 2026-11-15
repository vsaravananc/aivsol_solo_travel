import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/core/theme/app_theme.dart';
import 'package:aivsol_solo_travel/feature/history/presentation/widgets/history_trip_card_widget.dart';
import 'package:flutter/material.dart';

const List<TripHistoryItem> _historyTrips = [
  TripHistoryItem(
    from: 'Mumbai',
    to: 'Goa',
    days: 3,
    estimatedCost: 8400,
    dateRange: 'Nov 14 – Nov 18',
    travelStyle: 'Standard Style',
  ),
   TripHistoryItem(
    from: 'Mumbai',
    to: 'Goa',
    days: 3,
    estimatedCost: 8400,
    dateRange: 'Nov 14 – Nov 18',
    travelStyle: 'Standard Style',
  ), TripHistoryItem(
    from: 'Mumbai',
    to: 'Goa',
    days: 3,
    estimatedCost: 8400,
    dateRange: 'Nov 14 – Nov 18',
    travelStyle: 'Standard Style',
  ), TripHistoryItem(
    from: 'Mumbai',
    to: 'Goa',
    days: 3,
    estimatedCost: 8400,
    dateRange: 'Nov 14 – Nov 18',
    travelStyle: 'Standard Style',
  ), TripHistoryItem(
    from: 'Mumbai',
    to: 'Goa',
    days: 3,
    estimatedCost: 8400,
    dateRange: 'Nov 14 – Nov 18',
    travelStyle: 'Standard Style',
  ),
  TripHistoryItem(
    from: 'Kochi',
    to: 'Munnar',
    days: 2,
    estimatedCost: 5200,
    dateRange: 'Nov 20 – Nov 22',
    travelStyle: 'Budget Style',
  ),
  TripHistoryItem(
    from: 'Bengaluru',
    to: 'Varkala',
    days: 4,
    estimatedCost: 12500,
    dateRange: 'Dec 01 – Dec 05',
    travelStyle: 'Comfort Style',
  ),
  TripHistoryItem(
    from: 'Delhi',
    to: 'Manali',
    days: 5,
    estimatedCost: 15800,
    dateRange: 'Dec 10 – Dec 15',
    travelStyle: 'Standard Style',
  ),
  TripHistoryItem(
    from: 'Chennai',
    to: 'Pondicherry',
    days: 2,
    estimatedCost: 4600,
    dateRange: 'Dec 18 – Dec 20',
    travelStyle: 'Budget Style',
  ),
  TripHistoryItem(
    from: 'Jaipur',
    to: 'Udaipur',
    days: 3,
    estimatedCost: 9200,
    dateRange: 'Dec 24 – Dec 27',
    travelStyle: 'Comfort Style',
  ),
  TripHistoryItem(
    from: 'Kolkata',
    to: 'Darjeeling',
    days: 4,
    estimatedCost: 11000,
    dateRange: 'Jan 05 – Jan 09',
    travelStyle: 'Standard Style',
  ),
  TripHistoryItem(
    from: 'Hyderabad',
    to: 'Hampi',
    days: 3,
    estimatedCost: 7800,
    dateRange: 'Jan 15 – Jan 18',
    travelStyle: 'Budget Style',
  ),
];

class HistoryRecentSearchTrips extends StatelessWidget {
  const HistoryRecentSearchTrips({super.key});

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
      body:  _HistoryTripListWidget(trips: _historyTrips),
    );
  }
}

class _HistoryTripListWidget extends StatelessWidget {
  final List<TripHistoryItem> trips;

  const _HistoryTripListWidget({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: trips.length,
      padding: const .only(left: 12,right: 12,top: 12,bottom: 50),
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) => HistoryTripCardWidget(
        trip: trips[index],
      ),
    );
  }
}
