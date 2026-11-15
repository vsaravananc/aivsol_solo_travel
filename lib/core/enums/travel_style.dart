import 'package:flutter/material.dart';

enum TravelStyle {
  budget(
    label: 'Budget',
    description: 'Affordable stays and essential travel options.',
    icon: Icons.savings_outlined,
  ),
  standard(
    label: 'Standard',
    description: 'Balanced comfort with popular stays and activities.',
    icon: Icons.luggage_outlined,
  ),
  comfort(
    label: 'Comfort',
    description: 'Premium hotels, luxury stays, and seamless experiences.',
    icon: Icons.diamond_outlined,
  );

  final String label;
  final String description;
  final IconData icon;

  const TravelStyle({
    required this.label,
    required this.description,
    required this.icon,
  });
}
