import 'package:aivsol_solo_travel/core/utility/api_end_points.dart';
import 'package:flutter/material.dart';

enum ShareOption {
  googleMaps(
    title: 'Open in Google Maps',
    subtitle: 'Explore your destination',
    icon: Icons.map_outlined,
    url: '${ApiEndPoints.map}{destination}',
  ),
  flightsTrains(
    title: 'Find Flights / Trains',
    subtitle: 'Compare travel options',
    icon: Icons.flight_takeoff_outlined,
    url:
        '${ApiEndPoints.flight}?q=flights+to+{destination}from+{from}+on+{fromdate}+through+{destinationdate}',
  ),
  hotels(
    title: 'Find Hotels',
    subtitle: 'Find accommodation for your dates',
    icon: Icons.hotel_outlined,
    url:
        '${ApiEndPoints.hotel}?q=hotels+in+{destination}+on+{fromdate}+through+{destinationdate}',
  ),
  shareTrip(
    title: 'Share Trip Plan',
    subtitle: 'Share your itinerary with friends',
    icon: Icons.share_outlined,
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final String? url;

  ShareOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.url,
  });

  String? buildUrl({
    String destination = '',
    String from = '',
    String fromdate = '',
    String destinationdate = '',
  }) {
    return url
        ?.replaceAll('{destination}', Uri.encodeComponent(destination))
        .replaceAll('{from}', Uri.encodeComponent(from))
        .replaceAll('{fromdate}', Uri.encodeComponent(fromdate))
        .replaceAll('{destinationdate}', Uri.encodeComponent(destinationdate));
  }
}
